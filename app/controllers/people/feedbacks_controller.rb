class People::FeedbacksController < People::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    @feedbacks = FeedbackDecorator.decorate_collection(@employee.feedbacks)
    @feedback = Feedback.new
  end

  def create
    @feedback = @employee.feedbacks.new feedback_params
    @feedback.user_id = current_user.id
    respond_to do |format|
      if @feedback.save
        @feedback = Feedback.new
        format.html { redirect_to person_feedbacks_path(@employee), notice: "Feedback was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "people/feedbacks/form", locals: {}) }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to person_feedbacks_path(@employee), notice: "Feedback was removed successfully." }
    end
  end

  def show
    fresh_when @feedback
  end

  private

  def set_feedback
    @feedback = Feedback.find(params["id"]).decorate
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
