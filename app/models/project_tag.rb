class ProjectTag < ApplicationRecord
  acts_as_tenant :account
  has_and_belongs_to_many :projects, touch: true

  validates_presence_of :name
  validates_uniqueness_to_tenant :name

  before_destroy { |tag| tag.projects.touch_all }
  after_create { |tag| tag.account.projects.touch_all }
end
