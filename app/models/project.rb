class Project < ApplicationRecord
  acts_as_tenant :account

  has_many :schedules
  has_many :participants, through: :schedules, source: :user

  belongs_to :manager, class_name: "User"
  has_many :notes, as: :notable
  has_many :feedbacks, as: :critiquable

  belongs_to :discipline

  validates_presence_of :name
end
