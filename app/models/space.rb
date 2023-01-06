class Space < ActiveRecord::Base
  acts_as_tenant :account
  belongs_to :user
  has_many :messages, dependent: :destroy
  validates_presence_of :title, :description
end
