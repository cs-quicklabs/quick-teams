class Ticket < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :discipline
  belongs_to :ticket_label, optional: true
  belongs_to :ticket_status, optional: true
  validates_presence_of :title, :description
  belongs_to :account
  acts_as_tenant :account
  has_many :comments, as: :commentable, dependent: :destroy

  scope :progress, -> { where(ticketstatus: :false) }
  scope :completed, -> { where(ticketstatus: :true) }
end
