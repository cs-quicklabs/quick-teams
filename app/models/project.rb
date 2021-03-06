class Project < ApplicationRecord
  acts_as_tenant :account

  has_many :schedules
  has_many :participants, through: :schedules, source: :user

  belongs_to :manager, class_name: "User"
  has_many :notes, as: :notable
  has_many :feedbacks, as: :critiquable

  belongs_to :discipline

  validates_presence_of :name

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }

  def potential_participants
    User.for_current_account.active.where.not(id: participants).order(:first_name)
  end
end
