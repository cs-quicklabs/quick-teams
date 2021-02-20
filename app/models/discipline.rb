class Discipline < ApplicationRecord
  acts_as_tenant :account
  has_many :employees, class_name: "User"

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create_commit { broadcast_prepend_to "disciplines" }
  after_update_commit { broadcast_replace_to "disciplines" }
  after_destroy_commit { broadcast_remove_to "disciplines" }
end
