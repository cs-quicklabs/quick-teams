class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :critiquable, polymorphic: true
  has_rich_text :body

  validates_presence_of :title

  scope :published, -> { where(published: true) }
end
