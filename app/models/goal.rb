class Goal < ApplicationRecord
  enum status: [:progress, :completed, :missed, :discarded]

  belongs_to :user
  belongs_to :goalable, polymorphic: true
  has_rich_text :body
  has_many :comments, dependent: :destroy
  validates_presence_of :title
end
