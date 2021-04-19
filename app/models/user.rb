class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
  has_many :events, as: :eventable
  has_many :notes
  has_many :timesheets
  belongs_to :status, class_name: "PeopleStatus", optional: true

  validates_presence_of :first_name, :last_name, :email, :role, :job, :discipline, :account

  def potential_projects
    participated_project_ids = schedules.pluck(:project_id)
    Project.active.where.not(id: participated_project_ids)
  end
end
