class TicketLabel < ApplicationRecord
  has_many :tickets
  belongs_to :user
  belongs_to :discipline
  belongs_to :account
  validates_presence_of :name
  acts_as_tenant :account
end
