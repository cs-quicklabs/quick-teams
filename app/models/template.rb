class Template < ApplicationRecord
  acts_as_tenant :account

  belongs_to :user
  has_rich_text :body
  has_many :templates_assignees

  validates_presence_of :title
end
