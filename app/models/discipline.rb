class Discipline < ApplicationRecord
  acts_as_tenant :account
  has_many :employees, class_name: "User"
  has_many :kbs
  has_many :ticket_labels
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
