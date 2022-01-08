class Account < ApplicationRecord
  validates_presence_of :name

  has_many :projects
  has_many :users
end
