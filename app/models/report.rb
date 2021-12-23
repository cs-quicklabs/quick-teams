class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  has_rich_text :body
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title  
  scope :submitted, -> { where(submitted: true) }
  scope :pending, -> { where(submitted: false) }

  def clone(template, employee, actor)
    self.title = template.title
    self.body = template.body
    self.reportable = employee
    self.user = actor
    self.save!
  end

  def self.query(params, includes = nil, order)
    return [] if params.empty?
    ReportQuery.new(self.includes(includes), params, order).filter
  end
end
