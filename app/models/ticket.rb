class Ticket < ApplicationRecord
  acts_as_tenant :account

  belongs_to :user, optional: true
  belongs_to :discipline, optional: true
  belongs_to :ticket_label
  belongs_to :ticket_status, optional: true
  validates_presence_of :description

  has_many :comments, as: :commentable, dependent: :destroy

  scope :progress, -> { where(ticketstatus: :false) }
  scope :completed, -> { where(ticketstatus: :true) }
end
