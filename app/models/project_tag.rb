class ProjectTag < ApplicationRecord
  acts_as_tenant :account
  has_and_belongs_to_many :projects

  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
