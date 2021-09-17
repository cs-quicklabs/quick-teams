class SurveysController < BaseController
  include Pagy::Backend
  before_action :set_survey, only: %i[ show edit update destroy clone assignees ]

  def index
    authorize :surveys
    @pagy, @surveys = pagy_nil_safe(params, Survey::Survey.includes(:actor).all.order(created_at: :desc), items: LIMIT)
    render_partial("surveys/survey", collection: @surveys, cached: true) if stale?(@surveys)
  end

  def new
    authorize :surveys
    @survey = Survey::Survey.new
  end

  def edit
    authorize :surveys
  end

  def destroy
    authorize :surveys
    @survey.destroy
    redirect_to surveys_path, notice: "Survey was removed successfully."
  end

  def update
    authorize :surveys
    if @survey.update(survey_params)
      redirect_to survey_questions_path(@survey), notice: "Survey was updated successfully."
    else
      redirect_to edit_survey_path(@survey), alert: "Failed to update survey."
    end
  end

  def create
    authorize :surveys
    @survey = Survey::Survey.new(survey_params)
    @survey.actor_id = current_user.id
    if @survey.save
      redirect_to survey_questions_path(@survey)
    else
      redirect_to new_survey_path, alert: "Failed to create survey."
    end
  end

  def show
    authorize :surveys
    redirect_to survey_questions_path(@survey)
  end

  def clone
    authorize :surveys

    @clone = @survey.clone_for_actor(current_user)
    if @clone.id.nil?
      redirect_to new_survey_path, alert: "Failed to clone survey. You can try creating a new one."
    else
      redirect_to survey_questions_path(@clone), notice: "Survey was cloned successfully."
    end
  end

  def assignees
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey_survey).permit(:name, :survey_type, :description, :survey_for, :actor_id)
  end
end
