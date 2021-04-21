class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :goal

  validates_presence_of :title
end
