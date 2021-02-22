class ProjectTag < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :name
  validates_uniqueness_of :name

  after_create_commit { broadcast_prepend_to "project_tags" }
  after_update_commit { broadcast_replace_to "project_tags" }
  after_destroy_commit { broadcast_remove_to "project_tags" }
end
