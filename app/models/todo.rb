class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :project, optional: true

  validates_presence_of :user, :title, :deadline

  scope :pending, -> { where(completed: false) }
end
