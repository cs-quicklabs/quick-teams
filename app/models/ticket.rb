class Ticket < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :discipline, optional: true
  belongs_to :ticket_label, optional: true
  belongs_to :ticket_status, optional: true
  validates_presence_of :title, :description
  belongs_to :account
  acts_as_tenant :account
end
