class TicketLabel < ApplicationRecord
  acts_as_tenant :account

  has_many :tickets
  belongs_to :user
  belongs_to :discipline
  validates_presence_of :name
  before_destroy { |ticket_label| ticket_label.tickets.touch_all }
end
