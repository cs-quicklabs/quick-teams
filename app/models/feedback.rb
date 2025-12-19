class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :critiquable, polymorphic: true
  has_rich_text :body

  validates_presence_of :title, :body

  scope :published, -> { where(published: true) }

  enum :feedback_type, { positive: 0, negative: 1, neutral: 2 }

  attribute :is_kpi, :boolean, default: false
end
