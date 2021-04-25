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
        @milestone = Goal.new
        format.html { redirect_to project_milestones_path(@project), notice: "Milestone was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Goal.new, partial: "project/milestones/form", locals: { milestone: @milestone }) }
      end
    end
  end

  def destroy
    authorize [:project, @goal]
    @milestone.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@milestone) }
    end
  end

  def show
    authorize [:project, @goal]

    @comment = Comment.new
    fresh_when @milestone
  end

  private

  def set_milestone
    @milestone ||= Goal.find(params["id"])
  end

  def milestone_params
    params.require(:goal).permit(:title, :body, :deadline)
  end
end
