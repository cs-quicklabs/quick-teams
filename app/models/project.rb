class Project < ApplicationRecord
  acts_as_tenant :account

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :kpi, class_name: "Survey::Survey", optional: true
  belongs_to :discipline
  belongs_to :status, class_name: "ProjectStatus", optional: true

  has_many :schedules, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
  has_many :feedbacks, as: :critiquable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :documents, as: :documenter, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :milestones, as: :goalable, class_name: "Goal", dependent: :destroy
  has_many :timesheets, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :risks, dependent: :destroy
  has_many :attempts, as: :participant, class_name: "Survey::Attempt", dependent: :destroy
  has_many :templates_assignees, as: :assignable, dependent: :destroy
  has_many :lists, through: :todos, source: :user
  has_many :participants, through: :schedules, source: :user
  has_and_belongs_to_many :project_tags, dependent: :destroy
  has_and_belongs_to_many :skills, dependent: :destroy
  has_and_belongs_to_many :clients, dependent: :destroy
  has_many :project_observers, dependent: :destroy
  has_many :observers, through: :project_observers, source: :user

  validates_presence_of :name

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  scope :available, -> { active }

  def potential_participants
    User.includes(:job, :role, :discipline).for_current_account.active.where.not(id: participants).order(:first_name)
  end

  before_update :update_schedules, :if => :billable_changed?

  def update_schedules
    # bust cache and recalculate occupancy
    # this is a hack because scheduled are cached with employees.
    # need to find a better way for this
    participants.touch_all
  end

  def reset_billable_resources
    self.update_attribute(:billable_resources, calculate_billable_resources)
  end

  def calculate_billable_resources
    self.schedules.reduce(0.0) do |sum, schedule|
      sum += schedule.billable ? (schedule.occupancy / 100.0) : 0.0
      sum
    end
  end

  def self.query(params, includes = nil)
    return [] if params.empty?
    ProjectQuery.new(self.includes(:manager), params).filter
  end

  def surveys
    Survey::Survey.surveys.where(survey_for: :project)
  end

  def filled_surveys
    Survey::Attempt.includes(:survey).where(participant_id: id, survey_id: surveys.ids, participant_type: "Project")
  end
end
