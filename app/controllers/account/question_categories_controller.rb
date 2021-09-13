class Account::QuestionCategoriesController < Account::BaseController
  before_action :set_question_category, only: %i[ show edit update destroy ]
  before_action :set_account

  def index
    authorize :account

    @question_categories = QuestionCategory.all.order(created_at: :desc)
    @question_category = QuestionCategory.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @question_category = QuestionCategory.new(question_category_params)
    @question_category.account_id = @account.id
    respond_to do |format|
      if @question_category.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:question_categories, partial: "account/question_categories/question_category", locals: { question_category: @question_category }) +
                               turbo_stream.replace(QuestionCategory.new, partial: "account/question_categories/form", locals: { question_category: QuestionCategory.new, message: "Survey question category was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(QuestionCategory.new, partial: "account/question_categories/form", locals: { question_category: @question_category }) }
      end
    end
  end

  def edit
    authorize :account
  end

  def update
    authorize :account

    respond_to do |format|
      if @question_category.update(question_category_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@question_category, partial: "account/question_categories/question_category", locals: { question_category: @question_category, message: "Survey question category updated successfully." }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@question_category, template: "account/question_categories/form", locals: { question_category: @question_category, messages: @question_category.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @question_category.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question_category) }
    end
  end

  private

  def set_account
    @account ||= Account.find(current_user.account_id)
  end

  def set_question_category
    @question_category ||= QuestionCategory.find(params[:id])
  end

  def question_category_params
    params.require(:question_category).permit(:name, :account_id)
  end
end
