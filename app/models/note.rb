class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user
  validates_presence_of :body, :notable
end
