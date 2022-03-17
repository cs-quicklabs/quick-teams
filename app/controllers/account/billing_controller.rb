class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account, :billings?
  end
end
