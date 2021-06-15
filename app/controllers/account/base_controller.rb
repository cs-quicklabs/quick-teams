class Account::BaseController < BaseController
  after_action :verify_authorized
end
