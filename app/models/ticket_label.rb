class TicketLabel < ApplicationRecord
  acts_as_tenant :account

  has_many :tickets
  belongs_to :user
  belongs_to :discipline
  validates_presence_of :name
end
