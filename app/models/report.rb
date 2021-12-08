class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  has_rich_text :body
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title, :body
  scope :submitted, -> { where(submitted: true) }
  def self.query(params, includes = nil, order)
    return [] if params.empty?
    ReportQuery.new(self.includes(includes), params, order).filter
  end
end
