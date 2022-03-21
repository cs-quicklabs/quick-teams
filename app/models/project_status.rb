class ProjectStatus < ApplicationRecord
  acts_as_tenant :account

  has_one :project, :class_name => "Project", :foreign_key => "status_id" 

  validates_presence_of :name
  validates_uniqueness_to_tenant :name

  before_destroy { |status| if status.project.present?
   status.project.touch 
end}
  after_create { |status| status.account.projects.touch_all }
end
