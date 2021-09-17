class Survey::QuestionCategory < ApplicationRecord
  self.table_name = "survey_question_categories"

  validates_presence_of :name
end
