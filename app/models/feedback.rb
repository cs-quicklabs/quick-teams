class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :critiquable, polymorphic: true
  has_rich_text :body
end
