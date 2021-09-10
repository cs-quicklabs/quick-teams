class Survey::AttemptsController < Survey::BaseController
  before_action :set_survey, only: [:index, :update, :destroy, :show, :new, :create, :preview]
   before_action :set_participant, only: [:preview]

  def index

    authorize [:survey, :attempt]
    @attempts = Survey::Attempt.joins(:user).find_by_survey_id(@survey.id).limit(50)
    binding.irb
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

  def preview
    authorize [:survey, :attempt]
    @attempt = Survey::Attempt.find(params[:id])

    if @attempt.survey.survey_type == 0
      redirect_to survey_checklist_report_path(@survey, @attempt)
    else
      redirect_to survey_score_report_path(@survey, @attempt)
    end
  end

  private

  def set_survey
     @survey = Survey::Survey.find(params[:survey_id])
  end
  def attempt_params
    params.require(:survey_attempt).permit(:participant_id, :actor_id, :survey_id)
  end
  def set_participant
     @participant = User.find(@attempt.participant_id)
  end
end
