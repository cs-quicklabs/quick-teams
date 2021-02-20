class Project < ApplicationRecord
  acts_as_tenant :account

  has_one :manager
  belongs_to :discipline
  validates_presence_of :name
end
