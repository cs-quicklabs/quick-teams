class Projects::FeedbacksController < Projects::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    @feedbacks = FeedbackDecorator.decorate_collection(@project.feedbacks)
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

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to project_feedbacks_path(@project), notice: "Feedback was removed successfully." }
    end
  end

  def show
  end

  private

  def set_feedback
    @feedback = Feedback.find(params["id"]).decorate
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
