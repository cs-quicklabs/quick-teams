class SurveysController < BaseController
  before_action :set_survey, only: %i[ show edit update destroy clone ]

  def index
    authorize :surveys
    @pagy, @surveys = pagy_nil_safe(params, Survey::Survey.all.order(:name), items: LIMIT)
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
    redirect_to surveys_path
  end

  def update
    authorize :surveys
    @survey.update(survey_params)
    redirect_to survey_path(@survey)
  end

  def create
    authorize :surveys
    @survey = Survey::Survey.new(survey_params)
    @survey.actor_id = current_user.id
    redirect_to survey_path(@survey) if @survey.save
  end

  def show
    authorize :surveys
    redirect_to survey_questions_path(@survey)
  end

  def clone
    authorize :surveys
    @clone = Survey::Survey.new
    @clone.name = @survey.name + " (Copy)"
    @clone.survey_type = @survey.survey_type
    @clone.actor_id = current_user.id
    @clone.description = @survey.description.nil? ? "N/A" : @survey.description
    @clone.save

    @survey.questions.each do |question|
      q = Survey::Question.new(text: question.text, description: question.description, survey_id: @clone.id)
      q.save

      if @survey.survey_type == 0 #checklist
        Survey::Option.new(text: "Yes", question: q, correct: true, weight: 1).save
        Survey::Option.new(text: "No", question: q, correct: false, weight: 0).save
      else
        Survey::Option.new(text: "Score", question: q, correct: true, weight: 10).save
      end
    end

    redirect_to survey_path(@clone)
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey_survey).permit(:name, :survey_type, :description, :survey_for, :actor_id)
  end
end
