class Project < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :name
end
