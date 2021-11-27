class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  has_rich_text :body
  validates_presence_of :title, :body
  scope :submitted, -> { where(submitted: true) }
end
