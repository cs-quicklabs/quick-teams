class Survey::QuestionCategory < ApplicationRecord
  self.table_name = "survey_question_categories"
  acts_as_tenant :account
  has_many :questions, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
