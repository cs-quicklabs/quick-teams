class Project::MilestonesController < Project::BaseController
  before_action :set_milestone, only: %i[show destroy]

  def index
    authorize [:project, Goal]

    @milestones = @project.milestones.includes({ comments: :user }).order(created_at: :desc)
    @milestone = Goal.new
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
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@milestone) }
    end
  end

  def show
    authorize [:project, @milestone]

    @comment = Comment.new
    fresh_when @milestone
  end

  private

  def set_milestone
    @milestone ||= Goal.find_by(id: params["id"], goalable_type: "Project")
  end

  def milestone_params
    params.require(:goal).permit(:title, :body, :deadline)
  end
end
