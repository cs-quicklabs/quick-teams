class Nugget < ApplicationRecord
  belongs_to :user
  belongs_to :skill
  has_rich_text :body

  validates_presence_of :title, :body

  scope :published_for_skill, ->(skill) { published.where(skill: skill) }

  def self.query(params, includes = nil, order)
    return [] if params.empty?
    NuggetQuery.new(self.includes(includes), params, order).filter
  end

end
