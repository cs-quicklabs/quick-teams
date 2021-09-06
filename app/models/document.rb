class Document < ApplicationRecord
  belongs_to :user
  belongs_to :documenter, polymorphic: true

  validates_presence_of :filename, :link
  validates :link, :url => true
end
