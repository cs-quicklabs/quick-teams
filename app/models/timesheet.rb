class Timesheet < ApplicationRecord
  acts_as_tenant :account

  validates :user, :project, :date, presence: true
  validates :value, presence: true, numericality: { greater_than: 0,
                                                    only_integer: true }

  belongs_to :project
  belongs_to :user
end
