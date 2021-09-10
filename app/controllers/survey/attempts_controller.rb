class Survey::AttemptsController < Survey::BaseController
  before_action :set_survey, only: [:index, :edit, :update, :destroy, :show]

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
    @participant = Survey::Participant.create(name: params[:name], email: params[:email])
    @attempt = Survey::Attempt.create(survey: @survey, participant: @participant)
    redirect_to survey_new_attempt_path(@attempt)
  end

  def show
     authorize [:survey, :attempt]
    @attempt = Attempt.find(params[:id])
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
end
