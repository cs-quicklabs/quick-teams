class Projects::FeedbacksController < Projects::BaseController
  def index
    @feedbacks = @project.feedbacks
    @feedback = Feedback.new
  end

  def create
    @feedback = @project.feedbacks.new feedback_params
    @feedback.user_id = current_user.id
    respond_to do |format|
      if @feedback.save
        @feedback = Feedback.new
        format.html { redirect_to project_feedbacks_path(@project), notice: "Feedback was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "projects/feedbacks/form", locals: {}) }
      end
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
