class Survey::AttemptsController < Survey::BaseController
  before_action :set_survey, only: [:index, :update, :destroy, :show, :new, :create, :preview]
  before_action :set_attempt, only: [:preview, :show]
  before_action :set_participant, only: [:preview]

  def index
    authorize [:survey, :attempt]
    @attempts = Survey::Attempt.where(survey: @survey).where(submitted: true)
  end

  def new
    authorize [:survey, :attempt]
    if params[:participant_id]
      attempt = create_attempt(params[:participant_id])
      redirect_to survey_attempt_path(@survey, attempt)
    else
      @attempt = Survey::Attempt.new
    end
  end

  def create
    authorize [:survey, :attempt]
    attempt = create_attempt(params[:participant_id])
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

  private

  def create_attempt(participant_id)
    attempt = Survey::Attempt.new
    attempt.participant_id = participant_id
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

  def set_participant
    @participant = User.find(@attempt.participant_id)
  end
end
