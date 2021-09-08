class AddExplanationToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_questions, :explanation, :string
  end
end
