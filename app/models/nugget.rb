class Nugget < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  has_rich_text :body

  validates_presence_of :title, :body

  scope :published, -> { where(published: true) }
  scope :published_for_skill, ->(skill) { published.where(skill: skill) }
end
