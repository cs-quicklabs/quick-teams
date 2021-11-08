class Risk < ApplicationRecord
  belongs_to :user
  belongs_to :project
  validates_presence_of :body
  scope :open, -> { where(status: true).order(created_at: :desc) }
end
