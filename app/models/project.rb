class Project < ApplicationRecord
  acts_as_tenant :account

  has_many :schedules
  has_many :participants, through: :schedules, source: :user

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :kpi, class_name: "Survey::Survey", optional: true

  has_many :notes, as: :notable
  has_many :feedbacks, as: :critiquable
  has_many :reports, as: :reportable
  has_many :documents, as: :documenter
  has_many :events, as: :eventable
  has_many :milestones, as: :goalable, class_name: "Goal"
  has_many :timesheets
  has_many :todos
  has_many :risks
  has_many :attempts, as: :participant
  has_many :templates_assignees, as: :assignable
  has_many :lists, through: :todos, source: :user
  has_and_belongs_to_many :project_tags
  has_and_belongs_to_many :skills

  belongs_to :discipline
  belongs_to :status, class_name: "ProjectStatus", optional: true
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
