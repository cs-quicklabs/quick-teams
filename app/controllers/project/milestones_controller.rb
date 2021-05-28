class Project::MilestonesController < Project::BaseController
  before_action :set_milestone, only: %i[show destroy edit update]

  def index
    authorize [:project, Goal]

    @milestone = Goal.new
    @pagy, @milestones = pagy_nil_safe(@project.milestones.includes(:user).order(created_at: :desc), items: LIMIT)
    render_partial("project/milestones/milestone", collection: @milestones) if stale?(@milestones)
  end

  def create
    authorize [:project, Goal]

    @milestone = AddProjectMilestone.call(@project, milestone_params, current_user).result
    respond_to do |format|
      if @milestone.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:milestones, partial: "project/milestones/milestone", locals: { milestone: @milestone }) +
                               turbo_stream.replace(Goal.new, partial: "project/milestones/form", locals: { milestone: Goal.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Goal.new, partial: "project/milestones/form", locals: { milestone: @milestone }) }
      end
    end
  end

  def destroy
    authorize [:project, @milestone]
    @milestone.destroy
    Event.where(eventable: @project, trackable: @milestone).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@milestone) }
    end
  end

  def show
    authorize [:project, @milestone]

    @comment = Comment.new
    fresh_when @milestone
  end

  def edit
    authorize [:project, @milestone]
  end

  def update
    authorize [:project, @milestone]

    respond_to do |format|
      if @milestone.update(milestone_params)
        format.html { redirect_to project_milestone_path(@milestone.goalable, @milestone), notice: "Milestone was successfully updated." }
      else
        format.html { redirect_to edit_project_milestone_path(@milestone.goalable, @milestone), alert: "Failed to update. Please try again." }
      end
    end
  end

  private

  def set_milestone
    @milestone ||= Goal.find_by(id: params["id"], goalable_type: "Project")
  end

  def milestone_params
    params.require(:goal).permit(:title, :body, :deadline)
  end
end
