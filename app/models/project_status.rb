class ProjectStatus < ApplicationRecord
  acts_as_tenant :account

  has_one :project

  validates_presence_of :name
  validates_uniqueness_to_tenant :name

  before_destroy { |status| status.project.touch }
  after_create { |status| status.account.projects.touch_all }
end
