class Event < ApplicationRecord
  acts_as_tenant :account

  belongs_to :user
  belongs_to :eventable, polymorphic: true
  belongs_to :trackable, polymorphic: true
end
