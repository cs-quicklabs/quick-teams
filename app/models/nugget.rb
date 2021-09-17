class Nugget < ApplicationRecord
  acts_as_tenant :account
  has_many :nuggets_users, :dependent => :destroy
  belongs_to :user
  belongs_to :skill
  has_rich_text :body
  has_many :nuggets_users, :dependent => :destroy

  validates_presence_of :title, :body

  def self.query(params, includes = nil, order)
    return [] if params.empty?
    NuggetQuery.new(self.includes(includes), params, order).filter
  end
end
