class Client < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :name, :email
  validates_uniqueness_to_tenant :email

  def display_client_name
    "#{name}".titleize
  end

end
