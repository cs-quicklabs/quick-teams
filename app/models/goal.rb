class Goal < ApplicationRecord
  enum status: [:progress, :completed, :missed, :discarded]

  belongs_to :user
  belongs_to :goalable, polymorphic: true
  has_rich_text :body
  has_many :comments, dependent: :destroy
  validates_presence_of :title

  scope :next_90_days, -> { where(deadline: Date.today..90.days.from_now) }
  scope :window_90_days, -> { where(deadline: 45.days.ago..45.days.from_now) }

  def self.query(params, includes = nil)
    GoalQuery.new(self.includes(includes), params).filter
  end
end
