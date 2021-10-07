class Risk < ApplicationRecord
  belongs_to :user
  belongs_to :project
  validates_presence_of :body
end
