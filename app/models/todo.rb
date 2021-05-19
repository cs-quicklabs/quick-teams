class Todo < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :project, touch: true
  # belongs_to :todoable, polymorphic: true
  validates_presence_of :user, :title, :deadline, :project
end
