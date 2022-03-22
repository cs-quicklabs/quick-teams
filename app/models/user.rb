class User < ApplicationRecord
  pay_customer

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable, and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable, timeout_in: 5.days, invite_for: 2.weeks

  enum permission: [:member, :lead, :admin]

  scope :for_current_account, -> { where(account: Current.account) }
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }
  scope :billable, -> { where(billable: true) }
  scope :all_users, -> { includes(:job, :role, :discipline).where(account: Current.account).active.order(:first_name) }
  scope :available, -> { all_users }

  belongs_to :account
  belongs_to :manager, class_name: "User", optional: true
  belongs_to :discipline
  belongs_to :role
  belongs_to :job
  belongs_to :kpi, class_name: "Survey::Survey", optional: true
  belongs_to :status, class_name: "PeopleStatus", optional: true

  has_many :schedules, dependent: :destroy
  has_many :projects, through: :schedules
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  has_many :feedbacks, as: :critiquable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  has_many :documents, as: :documenter, dependent: :destroy
  has_many :goals, as: :goalable, dependent: :destroy
  has_many :templates_assignees, as: :assignable, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :attempts, as: :participant, dependent: :destroy, class_name: "Survey::Attempt" #survey attempts as participant
  has_many :attempt, class_name: "Survey::Attempt", foreign_key: "actor_id"  # surveys attempts as actor
  has_many :surveys, class_name: "Survey::Survey", foreign_key: "actor_id" # survey created by user
  has_many :notes, dependent: :destroy
  has_many :templates
  has_many :timesheets, dependent: :destroy
  has_many :kbs
  has_many :tickets
  has_many :ticket_labels
  has_many :managed_projects, class_name: "Project", foreign_key: "manager_id"
  has_many :todos, class_name: "Todo", foreign_key: "owner_id", dependent: :destroy
  has_many :created_todos, class_name: "Todo", foreign_key: "user_id", dependent: :destroy
  has_many :comments, class_name: "Comment", foreign_key: "user_id", dependent: :destroy

  has_and_belongs_to_many :people_tags, dependent: :destroy
  has_and_belongs_to_many :skills, dependent: :destroy
  has_and_belongs_to_many :nuggets

  validates :email, uniqueness: true
  validates_presence_of :first_name, :last_name, :email, :role, :job, :discipline, :account

  def name
    "#{first_name} #{last_name}".titleize
  end

  def potential_projects
    participated_project_ids = schedules.pluck(:project_id)
    Project.active.where.not(id: participated_project_ids)
  end

  def potential_todos
    participated_todo_ids = todos.pluck(:project_id)
    Project.active.where.not(id: participated_todo_ids)
  end

  def subordinate?(employee)
    # level 1 subordinates
    all_subordinates_ids = self.subordinates.ids
    # early return on level one
    return true if all_subordinates_ids.include?(employee.id)

    # level 2 subordinates
    all_subordinates_ids << User.where("manager_id in (?)", all_subordinates_ids).ids
    all_subordinates_ids = all_subordinates_ids.flatten.uniq
    # early return on level two
    return true if all_subordinates_ids.include?(employee.id)

    # level 3 subordinates
    all_subordinates_ids << User.where("manager_id in (?)", all_subordinates_ids).ids
    all_subordinates_ids = all_subordinates_ids.flatten.uniq
    all_subordinates_ids.include?(employee.id)
  end

  def project_participant?(employee)
    projects = self.managed_projects.map(&:id)
    @employees ||= Schedule.where("project_id IN (?)", projects).pluck(:user_id)
    @project_participant ||= @employees.include?(employee.id)
  end

  def self.query(params, includes = nil)
    return [] if params.empty?
    EmployeeQuery.new(self.includes(:job, :role, :manager, :discipline), params).filter
  end

  def active_for_authentication?
    super and active
  end

  def project_manager?
    @project_manager ||= self.managed_projects.count > 0
  end

  def is_manager?(project)
    project.manager == self
  end

  def added_nuggets
    Nugget.where(user: self).includes(:user)
  end

  def published_nuggets
    nuggets.where(published: true).select("nuggets_users.read as read", "nuggets.*").includes(:skill).order(read: :ASC).order(created_at: :desc).uniq
  end

  def published_nuggets_for_skill(id)
    nuggets.where(published: true).select("nuggets_users.read as read", "nuggets.*").where(skill_id: id).includes(:skill).order(read: :ASC).order(created_at: :desc).uniq
  end

  def surveys
    Survey::Survey.surveys.where(survey_for: :user)
  end

  def filled_surveys
    Survey::Attempt.includes(:survey, :actor, :participant).where(actor_id: id, survey_id: surveys.ids, participant_type: "User")
  end

  def is_owner?
    self.id == account.owner_id
  end
end
