class PeopleStatus < ApplicationRecord
  acts_as_tenant :account

  has_one :user, :class_name => "User", :foreign_key => "status_id"

  validates_presence_of :name
  validates_uniqueness_to_tenant :name

  before_destroy { |status|
    if status.user.present?
      status.user.touch
    end
  }
  after_create { |status| User.where(account: status.account).touch_all }
end
