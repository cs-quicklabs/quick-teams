class AddCategoryToSurveyQuestions < ActiveRecord::Migration[6.1]
  def change
    remove_column :survey_questions, :category, :string
    add_column :survey_questions, :question_category_id, :integer, references: :survey_question_categories
  end
end
