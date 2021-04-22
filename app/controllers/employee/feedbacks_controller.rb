class Employee::FeedbacksController < Employee::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    authorize [:employee, Feedback]

    @feedbacks = FeedbackDecorator.decorate_collection(@employee.feedbacks.order(created_at: :desc))
    @feedback = Feedback.new
  end

  def create
    @feedback = AddEmployeeFeedback.call(@employee, feedback_params, current_user).result

    respond_to do |format|
      if @feedback.persisted?
        @feedback = Feedback.new
        format.html { redirect_to employee_feedbacks_path(@employee), notice: "Feedback was added successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "employee/feedbacks/form", locals: { feedback: @feedback }) }
      end
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to employee_feedbacks_path(@employee), notice: "Feedback was removed successfully." }
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
