class Skill < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  has_many :nuggets
end
