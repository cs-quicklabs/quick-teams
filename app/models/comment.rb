class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :goal, touch: true

  validates_presence_of :title
end
