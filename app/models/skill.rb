class Skill < ApplicationRecord
  acts_as_tenant :account
  has_and_belongs_to_many :users, :dependent => :destroy
  belongs_to :users
  has_many :nuggets, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
