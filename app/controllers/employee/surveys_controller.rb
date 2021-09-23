class Employee::SurveysController < Employee::BaseController
  before_action :set_employee, only: [:index, :quick_assessment]

  def index
    authorize [@employee, :survey]

    @surveys = @employee.surveys
    @pagy, @filled_surveys = pagy_nil_safe(params, @employee.filled_surveys.order(created_at: :desc), items: LIMIT)
    render_partial("employee/surveys/survey", collection: @filled_surveys, cached: true) if stale?(@filled_surveys + @surveys + [@employee])
  end

  def quick_assessment
    authorize [@employee, :survey], :index?

    survey = Survey::Survey.find(params[:survey_id])
    question = Survey::Question.find(attempt_params[:question_id])
    participant = User.find(attempt_params[:participant_id])
    actor = User.find(attempt_params[:actor_id])
    comment = attempt_params[:comment]
    score = attempt_params[:rating].to_i

    attempt = Survey::Attempt.create(participant: participant, actor: actor, survey: survey, comment: comment)
    answer = Survey::Answer.create(attempt: attempt, question: question, score: score, option: question.options.first)
    attempt.update(submitted: true, score: attempt.calculate_score)

    redirect_to employee_kpis_path(@employee), notice: "Assessment successfully submitted"
  end

  private

  def attempt_params
    params.require(:survey_attempt).permit(:question_id, :participant_id, :actor_id, :comment, :rating)
  end
end
