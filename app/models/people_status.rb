class PeopleStatus < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :name
  validates_uniqueness_of :name
end
