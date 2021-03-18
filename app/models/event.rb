class Event < ApplicationRecord
  belongs_to :user
  belongs_to :eventable, polymorphic: true
  belongs_to :trackable, polymorphic: true
end
