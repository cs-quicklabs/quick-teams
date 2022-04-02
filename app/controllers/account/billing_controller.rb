class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account, :billings?

    subscription_manager = SubscriptionManager.new(current_user)
    @template = subscription_manager.template

    if @template == "trial"
      @ends_at = subscription_manager.trial_ends_at
    end
    @template
  end
end
