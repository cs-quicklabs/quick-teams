class Kb < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_title, against: :document, using: { tsearch: { dictionary: "english" } }

  belongs_to :user
  belongs_to :job, optional: true
  belongs_to :discipline, optional: true
  validates :link, :url => true

  def self.query(params, includes = nil, order)
    return [] if params.empty?
    KbQuery.new(self.includes(includes), params, order).filter
  end
end
