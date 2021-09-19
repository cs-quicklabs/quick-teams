class Survey::QuestionCategory < ApplicationRecord
  self.table_name = "survey_question_categories"
  acts_as_tenant :account
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
