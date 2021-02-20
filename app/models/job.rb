class Job < ApplicationRecord
  acts_as_tenant :account
  has_many :employees, class_name: "User"

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create_commit { broadcast_prepend_to "jobs" }
  after_update_commit { broadcast_replace_to "jobs" }
  after_destroy_commit { broadcast_remove_to "jobs" }
end
