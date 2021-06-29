class Todo < ApplicationRecord
  acts_as_tenant :account

  belongs_to :user
  belongs_to :owner, class_name: "User"
  belongs_to :project, optional: true

  validates_presence_of :user, :title, :deadline

  scope :pending, -> { where(completed: false) }
  scope :finished, -> { where(completed: true) }
  scope :order_by_deadline, -> { order(deadline: :desc) }
  scope :order_by_created, -> { order(created_at: :desc) }
  scope :order_by_updated, -> { order(updated_at: :desc) }
  after_create_commit {broadcast_prepend_to "todos"}
  after_update_commit {broadcast_replace_to "todos"}
  after_destroy_commit {broadcast_remove_to "todos"}
end
