class Tag < ApplicationRecord
  acts_as_tenant :account
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  has_many :taggings, dependent: :destroy
end
