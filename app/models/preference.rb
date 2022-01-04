class Preference < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :key, :value
end
