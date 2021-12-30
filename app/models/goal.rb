class Goal < ApplicationRecord
  include Extractor::HashTag
  enum status: [:progress, :completed, :missed, :discarded]
  acts_as_tenant :account

  belongs_to :user
  belongs_to :goalable, polymorphic: true
  has_rich_text :body

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates_presence_of :title, :deadline, :body

  scope :next_90_days, -> { where(deadline: Date.today..90.days.from_now) }
  scope :window_90_days, -> { where(deadline: 45.days.ago..45.days.from_now) }
  scope :pending, -> { where(status: :progress) }

  after_save :set_tags_from_title

  def self.query(params, includes = nil, order_by, order)
    return [] if params.empty?
    GoalQuery.new(self.includes(includes), params, order_by, order).filter
  end

  private

  def set_tags_from_title
    tagnames = extract_hashtags(title)

    self.tags = tagnames.map do |tagname|
      Tag.where("name ILIKE ?", tagname.strip).first_or_initialize.tap do |tag|
        tag.name = tagname.strip
        tag.taggings << Tagging.new(taggable: self)
        tag.save!
      end
    end
  end
end
