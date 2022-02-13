class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account
    #@portal_session = current_user.payment_processor.billing_portal
  end
end
