class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  has_rich_text :body
  validates_presence_of :title, :body
  scope :submitted, -> { where(submitted: true) }
   def self.query(params, includes = nil, order)
    return [] if params.empty?
    ReportQuery.new(self.includes(includes), params, order).filter
  end
end
