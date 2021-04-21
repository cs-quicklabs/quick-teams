class Project < ApplicationRecord
  acts_as_tenant :account

  has_many :schedules
  has_many :participants, through: :schedules, source: :user

  belongs_to :manager, class_name: "User", optional: true
  has_many :notes, as: :notable
  has_many :feedbacks, as: :critiquable
  has_many :events, as: :eventable
  has_many :milestones, as: :goalable, class_name: "Goal"
  has_many :timesheets
  has_and_belongs_to_many :project_tags

  belongs_to :discipline
  belongs_to :status, class_name: "ProjectStatus", optional: true
  validates_presence_of :name

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }

  def potential_participants
    User.for_current_account.active.where.not(id: participants).order(:first_name)
  end
end
