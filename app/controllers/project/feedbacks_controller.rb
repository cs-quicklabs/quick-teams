class Project::FeedbacksController < Project::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    @feedbacks = @project.feedbacks.order(created_at: :desc)
    @feedback = Feedback.new
  end

  def create
    @feedback = AddProjectFeedback.call(@project, feedback_params, current_user).result
    respond_to do |format|
      if @feedback.persisted?
        @feedback = Feedback.new
        format.html { redirect_to project_feedbacks_path(@project), notice: "Feedback was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "project/feedbacks/form", locals: { feedback: @feedback }) }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@feedback) }
    end
  end

  def show
  end

  private

  def set_feedback
    @feedback = Feedback.find(params["id"])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
