class Job < ApplicationRecord
  acts_as_tenant :account
  has_many :employees, class_name: "User"

  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
