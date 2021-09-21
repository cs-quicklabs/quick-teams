class Survey::QuestionsController < Survey::BaseController
  before_action :set_question, only: [:edit, :update, :destroy, :show]
  before_action :set_survey, only: [:index, :edit, :update, :destroy, :show, :create]

  def index
    authorize [:survey, :question]
    @pagy, @questions = pagy_nil_safe(params, Survey::Question.includes(:question_category, :survey).where(survey_id: @survey).order_by_category, items: LIMIT)
    @question_categories = Survey::QuestionCategory.all.order(:name)
    @question = Survey::Question.new
    render_partial("survey/questions/question", collection: @questions, cached: true) if stale?(@questions + @question_categories + [@survey])
  end

  def edit
    authorize [:survey, :question]
    @question_categories = Survey::QuestionCategory.all.order(:name)
  end

  def new
    authorize [:survey, :question]
    @question = Survey::Question.new
  end

  def destroy
    authorize [:survey, :question]
    @question.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question) }
    end
  end

  def update
    authorize [:survey, :question]
    @question.update(question_params)
    respond_to do |format|
      if @question.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@question, partial: "survey/questions/question", locals: { survey: @survey, question: @question, question_categories: Survey::QuestionCategory.all.order(:name), notice: "Question was updated successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@question, partial: "survey/questions/form", locals: { survey: @survey, question: @question, question_categories: Survey::QuestionCategory.all.order(:name) }) }
      end
    end
  end

  def create
    authorize [:survey, :question]
    @question = Survey::Question.new(question_params)
    @question.survey = @survey
    @question.save

    add_options(@question, @survey)

    respond_to do |format|
      if @question.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:questions, partial: "survey/questions/question", locals: { question: @question }) +
                               turbo_stream.replace(Survey::Question.new, partial: "survey/questions/form", locals: { survey: @survey, question: Survey::Question.new, question_categories: Survey::QuestionCategory.all.order(:name), message: "Question was added successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Survey::Question.new, partial: "survey/questions/form", locals: { survey: @survey, question: @question, question_categories: Survey::QuestionCategory.all.order(:name) }) }
      end
    end
  end

  private

  def add_options(question, survey)
    if survey.checklist? #checklist
      Survey::Option.new(text: "Yes", question: question, correct: true, weight: 1).save
      Survey::Option.new(text: "No", question: question, correct: false, weight: 0).save
    else
      Survey::Option.new(text: "Score", question: question, correct: true, weight: 10).save
    end
  end

  def set_question
    @question = Survey::Question.find(params[:id])
  end

  def set_survey
    @survey = Survey::Survey.find(params[:survey_id])
  end

  def question_params
    params.require(:survey_question).permit(:text, :description, :survey_id, :question_category_id, :explanation)
  end
end
