class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum permission: [:member, :lead, :admin]

  scope :for_current_account, -> { where(account: Current.account) }
  scope :inactive, -> { where(active: false) }
  scope :active, -> { where(active: true) }

  belongs_to :account
  belongs_to :manager, class_name: "User", optional: true
  belongs_to :discipline
  belongs_to :role
  belongs_to :job

  has_many :schedules
  has_many :projects, through: :schedules
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  has_many :feedbacks, as: :critiquable
  has_many :goals, as: :goalable
  has_many :events, as: :eventable
  has_many :notes
  has_many :timesheets
  belongs_to :status, class_name: "PeopleStatus", optional: true

  validates_presence_of :first_name, :last_name, :email, :role, :job, :discipline, :account

  def potential_projects
    participated_project_ids = schedules.pluck(:project_id)
    Project.active.where.not(id: participated_project_ids)
  end

  def subordinate?(employee)
    # level 1 subordinates
    all_subordinates_ids = self.subordinates.ids

    # level 2 subordinates
    all_subordinates_ids << User.where("manager_id in (?)", all_subordinates_ids).ids
    all_subordinates_ids = all_subordinates_ids.flatten.uniq
    all_subordinates_ids.include?(employee.id)
  end
end
