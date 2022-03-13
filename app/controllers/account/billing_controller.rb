class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account
  end
end
