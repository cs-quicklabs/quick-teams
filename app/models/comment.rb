class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user, class_name: "User"
  belongs_to :commentable, polymorphic: true

  validates_presence_of :title
end
