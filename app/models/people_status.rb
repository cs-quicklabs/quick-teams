class PeopleStatus < ApplicationRecord
  acts_as_tenant :account

  has_one :user

  validates_presence_of :name
  validates_uniqueness_to_tenant :name
end
