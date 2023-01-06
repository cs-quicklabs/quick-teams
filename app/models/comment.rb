class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates_presence_of :title, :null => false

  has_rich_text :body
end
