class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :todoable, polymorphic: true
  validates_presence_of :title, :deadline
end
