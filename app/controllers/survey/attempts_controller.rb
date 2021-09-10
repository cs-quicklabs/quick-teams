class Survey::AttemptsController < Survey::BaseController
  before_action :set_survey, only: [:index, :update, :destroy, :show, :new, :create, :submit]

  def index

    authorize [:survey, :attempt]
    @attempts = Survey::Attempt.limit(50)
  end

  def new
    authorize [:survey, :attempt]
    @attempt = Survey::Attempt.new
  end

  def create
    authorize [:survey, :attempt]
    @attempt = Survey::Attempt.new(attempt_params)
    @attempt.survey_id=@survey.id
    @attempt.actor_id=current_user.id
    @attempt.save
    redirect_to survey_attempt_path(@survey, @attempt)
  end

  def show
     authorize [:survey, :attempt]
    @attempt = Survey::Attempt.find(params[:id])
  end

  def submit
    authorize [:survey, :attempt]
    @attempt = Survey::Attempt.find(params[:id])
    if @attempt.survey.survey_type == 0
      redirect_to survey_checklist_report_path(@attempt, format: :html)
    else
      redirect_to survey_score_report_path(@attempt, format: :html)
    end
  end

  private

  def set_survey
     @survey = Survey::Survey.find(params[:survey_id])
  end
  def attempt_params
    params.require(:survey_attempt).permit(:participant_id, :actor_id, :survey_id)
  end
   def participant_params
    params.permit(:name, :email)
  end
end
