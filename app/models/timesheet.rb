class Timesheet < ApplicationRecord
  acts_as_tenant :account

  validates :user, :project, :description, presence: true
  validates :date, presence: true, inclusion: { in: (Date.today - 30.days..Date.today), message: "can be within last 30 days only" }
  validates :hours, presence: true, numericality: { greater_than: 0, less_than: 24,
                                                    only_integer: true }

  belongs_to :project
  belongs_to :user
end
