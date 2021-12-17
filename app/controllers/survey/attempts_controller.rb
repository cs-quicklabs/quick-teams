class Survey::AttemptsController < Survey::BaseController
  include Pagy::Backend
  before_action :set_survey, only: [:index, :update, :destroy, :show, :new, :create, :preview, :survey_questions]
  before_action :set_attempt, only: [:destroy, :update]
  before_action :set_attempt_with_survey, only: [:preview, :show]
  before_action :set_participant, only: [:preview]
  before_action :attempt_for_questions, only: [:survey_questions]

  def index
    authorize [:survey, :attempt]
    @pagy, @attempts = pagy_nil_safe(params, Survey::Attempt.includes(:actor, :participant, :survey, :answers).where(survey: @survey).order(created_at: :desc), items: LIMIT)
    render_partial("survey/attempts/attempt", collection: @attempts, cached: true) if stale?(@attempts + [@survey])
  end

  def new
    authorize [:survey, :attempt]
    participant = resolve_participant

    if participant
      attempt = create_attempt(participant)
      redirect_to survey_attempt_path(@survey, attempt)
    else
      @attempt = Survey::Attempt.new
      @participants = potential_participants
    end
  end

  def create
    authorize [:survey, :attempt]
    @klass = @survey.survey_for.resolve_class
    participant = @klass.find(attempt_params[:participant_id])

    attempt = create_attempt(participant)
    redirect_to survey_attempt_path(@survey, attempt)
  end

  def show
    authorize [@attempt]
  end

  def survey_questions
    authorize [@attempt], :show?

    @questions = @attempt.survey.questions.includes(:options, :question_category).order_by_category
  end

  def preview
    authorize [@attempt]
  end

  def destroy
    authorize [@attempt]

    @attempt.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@attempt) }
    end
  end

  private

  def resolve_participant
    participant = nil
    if params[:participant_id]
      @klass = @survey.survey_for.resolve_class
      participant = @klass.find(params[:participant_id])
    end
    participant
  end

  def potential_participants
    participants = []
    klass = @survey.survey_for.resolve_class
    participants = klass.available if klass.respond_to?(:available)
    participants
  end

  def resolve_survey_for
    klass = @survey.survey_for.capitalize
    if klass === "Adhoc"
      klass = "User"
    end
    klass = klass.constantize
  end

  def create_attempt(participant)
    attempt = Survey::Attempt.new
    attempt.participant = participant
    attempt.survey_id = @survey.id
    attempt.actor_id = current_user.id
    attempt.save

    attempt
  end

  def set_survey
    @survey = Survey::Survey.find(params[:survey_id])
  end

  def attempt_params
    params.require(:survey_attempt).permit(:participant_id)
  end

  def set_attempt
    @attempt ||= Survey::Attempt.find(params[:id])
  end

  def set_attempt_with_survey
    @attempt ||= Survey::Attempt.includes(:actor, :participant, :answers, survey: [:questions]).find(params[:id])
  end

  def set_participant
    @klass = @attempt.survey.survey_for.resolve_class
    @participant ||= @klass.find(@attempt.participant_id)
  end

  def attempt_for_questions
    @attempt ||= Survey::Attempt.find(params[:attempt_id])
  end
end
