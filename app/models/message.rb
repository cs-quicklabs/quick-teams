class Message < ActiveRecord::Base
  acts_as_tenant :account
  belongs_to :space
  belongs_to :user
  has_rich_text :body
  validates_presence_of :body, :title
  has_many :comments, as: :commentable, dependent: :delete_all
end
