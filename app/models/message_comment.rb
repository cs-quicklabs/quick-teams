class MessageComment < ApplicationRecord
  belongs_to :user
  belongs_to :message
  validates :body, presence: true
  has_rich_text :body
end
