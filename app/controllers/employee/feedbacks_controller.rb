class Employee::FeedbacksController < Employee::BaseController
  before_action :set_feedback, only: %i[show destroy edit update]

  def index
    authorize [@employee, Feedback]

    @feedback = Feedback.new
    @pagy, @feedbacks = pagy_nil_safe(employee_feedbacks, items: LIMIT)
    render_partial("employee/feedbacks/feedback", collection: @feedbacks) if stale?(@feedbacks + [@employee])
  end

  def create
    authorize [@employee, Feedback]

    @feedback = AddEmployeeFeedback.call(@employee, feedback_params, current_user).result

    respond_to do |format|
      if @feedback.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:feedbacks, partial: "employee/feedbacks/feedback", locals: { feedback: @feedback }) +
                               turbo_stream.replace(Feedback.new, partial: "employee/feedbacks/form", locals: { feedback: Feedback.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "employee/feedbacks/form", locals: { feedback: @feedback }) }
      end
    end
  end

  def destroy
    authorize [@employee, @feedback]

    @feedback.destroy
    Event.where(eventable: @employee, trackable: @feedback).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@feedback) }
    end
  end

  def show
    authorize [@employee, @feedback]

    fresh_when @feedback
  end

  def edit
    authorize [@employee, @feedback]
  end

  def update
    authorize [@employee, @feedback]

    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to employee_feedback_path(@feedback.critiquable, @feedback), notice: "Feedback was successfully updated." }
      else
        format.html { redirect_to edit_employee_feedback_path(@feedback), alert: "Failed to update. Please try again." }
      end
    end
  end

  private

  def set_feedback
    @feedback ||= Feedback.find(params["id"])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end

  def employee_feedbacks
    feedbacks = []
    if current_user.admin?
      feedbacks = all_feedbacks
    elsif current_user.lead?
      feedbacks = self? ? published_feedbacks : all_feedbacks
    else
      feedbacks = published_feedbacks
    end
    feedbacks
  end

  def all_feedbacks
    @employee.feedbacks.includes(:user).order(created_at: :desc)
  end

  def published_feedbacks
    @employee.feedbacks.published.includes(:user).order(created_at: :desc)
  end

  def self?
    current_user == @employee
  end
end
