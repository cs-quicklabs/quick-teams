class TicketStatus < ApplicationRecord
  belongs_to :account
  acts_as_tenant :account
  has_many :tickets
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
