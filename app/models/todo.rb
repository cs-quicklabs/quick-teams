class Todo < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  validates_presence_of :user, :title, :deadline
end
