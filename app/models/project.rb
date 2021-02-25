class Project < ApplicationRecord
  acts_as_tenant :account

  has_many :schedules
  has_many :participants, through: :schedules, source: :user

  has_one :manager
  has_many :notes, as: :notable

  belongs_to :discipline

  validates_presence_of :name
end
