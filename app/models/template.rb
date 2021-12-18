class Template < ApplicationRecord
  acts_as_tenant :account
  belongs_to :user
  has_rich_text :body
  validates_presence_of :title
  acts_as_tenant :account
  has_many :templates_assignees
  scope :all_templates, -> { where(account: Current.account) }
end
