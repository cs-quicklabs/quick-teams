class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account, :billings?

    @template = SubscriptionManager.new(current_user).template
  end
end
