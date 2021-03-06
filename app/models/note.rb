class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  validates_presence_of :body
end
