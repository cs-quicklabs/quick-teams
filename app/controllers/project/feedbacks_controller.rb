class Project::FeedbacksController < Project::BaseController
  before_action :set_feedback, only: %i[show destroy]

  def index
    authorize [:project, Feedback]

    @feedbacks = @project.feedbacks.includes(:user).order(created_at: :desc).limit(100)
    @feedback = Feedback.new

    fresh_when @feedbacks
  end

  def create
    authorize [:project, Feedback]

    @feedback = AddProjectFeedback.call(@project, feedback_params, current_user).result
    respond_to do |format|
      if @feedback.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:feedbacks, partial: "project/feedbacks/feedback", locals: { feedback: @feedback }) +
                               turbo_stream.replace(Feedback.new, partial: "project/feedbacks/form", locals: { feedback: Feedback.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Feedback.new, partial: "project/feedbacks/form", locals: { feedback: @feedback }) }
      end
    end
  end

  def destroy
    authorize [:project, @feedback]

    @feedback.destroy
    Event.where(eventable: @project, trackable: @feedbacks).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@feedback) }
    end
  end

  def show
    authorize [:project, @feedback]

    fresh_when @feedbacks
  end

  private

  def set_feedback
    @feedback ||= Feedback.find(params["id"])
  end

  def feedback_params
    params.require(:feedback).permit(:title, :body)
  end
end
