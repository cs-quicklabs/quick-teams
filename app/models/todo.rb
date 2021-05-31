class Todo < ApplicationRecord
  acts_as_tenant :account

  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :project, optional: true

  validates_presence_of :user, :title, :deadline

  scope :pending, -> { where(completed: false).order(deadline: :asc) }
end
