class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :goalable, polymorphic: true
  has_rich_text :body
  has_many :comments
  validates_presence_of :title
end
