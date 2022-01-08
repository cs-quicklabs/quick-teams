class PeopleStatus < ApplicationRecord
  acts_as_tenant :account

  has_one :user

  validates_presence_of :name
  validates_uniqueness_to_tenant :name

  before_destroy { |status| status.user.touch }
  after_create { |status| status.account.users.touch_all }
end
