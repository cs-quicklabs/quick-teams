class Survey::AttemptsController < Survey::BaseController
  before_action :set_survey, only: [:index, :update, :destroy, :show, :new, :create, :preview]
  before_action :set_attempt, only: [:destroy, :update]
  before_action :set_attempt_with_survey, only: [:preview, :show]
  before_action :set_participant, only: [:preview]

  def index
    authorize [:survey, :attempt]
    @attempts = Survey::Attempt.where(survey: @survey).where(submitted: true)
  end

  def new
    authorize [:survey, :attempt]
    if params[:participant_id] && params[:participant_type]
      @klass = params[:participant_type].capitalize.constantize
      participant = @klass.find(params[:participant_id])
      attempt = create_attempt(participant)
      redirect_to survey_attempt_path(@survey, attempt)
    else
      @attempt = Survey::Attempt.new
    end
  end

  def create
    authorize [:survey, :attempt]
    participant_id = params[:participant_id].present? ? params[:participant_id] : attempt_params[:participant_id]
    participant_type = params[:participant_type].present? ? params[:participant_type] : attempt_params[:participant_type]
    @klass = participant_type.capitalize.constantize
    participant = @klass.find(participant_id)

    attempt = create_attempt(participant)
    redirect_to survey_attempt_path(@survey, attempt)
  end

  def show
    authorize [:survey, :attempt]
  end

  def preview
    authorize [:survey, :attempt]
    if @attempt.survey.checklist?
      redirect_to survey_checklist_report_path(@survey, @attempt)
    else
      redirect_to survey_score_report_path(@survey, @attempt)
    end
  end

  def destroy
    authorize [@attempt]

    @attempt.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@attempt) }
    end
  end

  private

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
    @attempt = Survey::Attempt.find(params[:id])
  end

  def set_attempt_with_survey
    @attempt = Survey::Attempt.includes(:answers, survey: [:questions]).find(params[:id])
  end

  def set_participant
    @participant = User.find(@attempt.participant_id)
  end
end
