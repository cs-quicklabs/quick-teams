class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :pwned_password


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

  validates_presence_of :first_name, :last_name, :email, :role, :job, :discipline, :account
end
