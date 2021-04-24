class Employee::FeedbacksController < Employee::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    authorize @employee

    @feedbacks = @employee.feedbacks.includes(:user).order(created_at: :desc)
    @feedback = Feedback.new

    fresh_when @feedbacks
  end

  def create
    authorize @employee, :create_feedback?

    @feedback = AddEmployeeFeedback.call(@employee, feedback_params, current_user).result

    respond_to do |format|
      if @feedback.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:feedbacks, partial: "employee/feedbacks/feedback", locals: { feedback: @feedback.decorate }) +
                               turbo_stream.replace(Feedback.new, partial: "employee/feedbacks/form", locals: { feedback: Feedback.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "employee/feedbacks/form", locals: { feedback: @feedback }) }
      end
    end
  end

  def destroy
    authorize [:employee, @feedback]

    @feedback.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@feedback) }
    end
  end

  def show
    authorize [:employee, @feedback]

    fresh_when @feedback
  end

  private

  def set_feedback
    @feedback ||= Feedback.find(params["id"])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
