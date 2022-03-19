class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account, :billings?

    @template = get_template
  end

  private

  def get_template
    template = "subscribe"

    payment_processor = current_user.payment_processor

    # user signed up and is under trial period
    # he has not done anything yet with payments
    if payment_processor.on_generic_trial?
      template = "trial"
      return template
    end

    # user has a stripe processor and no subscription
    # may be user tried to purchase a subscription but did not complete the payment
    if payment_processor.processor == "stripe" and payment_processor.subscription.nil?
      fake_customer = Pay::Customer.where(owner_type: "User", owner_id: current_user.id, processor: "fake_processor").first
      fake_subscription = Pay::Subscription.where(name: "default", customer_id: fake_customer.id)
      # he still has a fake subscription trial active
      if fake_subscription and fake_subscription.trial_ends_at > Time.zone.now
        template = "trial"
        return template
      end
    end

    # user has a stripe processor and subscription which was cancelled
    if payment_processor.subscription.cancelled?
      template = "renew"
      return template
    end

    if payment_processor.subscription.active?
      template = "manage"
      return template
    end
    template
  end
end
