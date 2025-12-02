class Comment < ApplicationRecord
  enum :status, { regress: 0, stale: 1, progress: 2 }

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates_presence_of :title, :null => false
end
