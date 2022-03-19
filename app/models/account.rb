class Account < ApplicationRecord
  validates_presence_of :name
has_many :users, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :timesheets, dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :project_tags, dependent: :destroy
  has_many :project_statuses, dependent: :destroy
  has_many :people_tags, dependent: :destroy
  has_many :people_statuses, dependent: :destroy
  has_many :nuggets, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :kbs, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :disciplines, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :preferences, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :ticket_labels, dependent: :destroy
  has_many :ticket_statuses, dependent: :destroy
end
