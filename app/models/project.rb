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
  has_many :todos
  has_many :lists, through: :todos, source: :user
  has_and_belongs_to_many :project_tags

  belongs_to :discipline
  belongs_to :status, class_name: "ProjectStatus", optional: true
  validates_presence_of :name

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }

  def potential_participants
    User.for_current_account.active.where.not(id: participants).order(:first_name)
  end

  before_update :update_schedules, :if => :billable_changed?

  def update_schedules
    # bust cache and recalculate occupancy
    # this is a hack because scheduled are cached with employees.
    # need to find a better way for this
    participants.touch_all
  end

  def self.query(params, includes = nil)
    return [] if params.empty?
    ProjectQuery.new(self.includes(:manager), params).filter
  end
end
