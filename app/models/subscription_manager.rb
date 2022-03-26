class SubscriptionManager
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def template
    payment_processor = user.payment_processor

    # user signed up and is under trial period
    # he has not done anything yet with payments
    if payment_processor.on_generic_trial?
      template = "trial"
      return template
    end

    # user has a stripe processor and no subscription
    # may be user tried to purchase a subscription but did not complete the payment
    if payment_processor.processor == "stripe" and payment_processor.subscription.nil?
      fake_customer = Pay::Customer.where(owner_type: "User", owner_id: user.id, processor: "fake_processor").first
      if fake_customer
        fake_subscription = Pay::Subscription.where(name: "default", customer_id: fake_customer.id)
        # he still has a fake subscription trial active
        if fake_subscription and fake_subscription.trial_ends_at > Time.zone.now
          template = "trial"
          return template
        end
      end

      template = "subscribe"
      return template
    end

    # user has a stripe processor and subscription which was cancelled but is still under grace period
    if payment_processor.subscription.cancelled? and payment_processor.subscription.ends_at > Time.zone.now
      template = "renew"
      return template
    end

    # user has an active stripe subscription
    if payment_processor.subscription.active?
      template = "manage"
      return template
    end

    # user has a stripe processor and subscription which was cancelled and grace period is over
    if payment_processor.subscription.cancelled? and payment_processor.subscription.ends_at < Time.zone.now
      template = "expired"
      return template
    end

    # user has an expired trial subscription
    if payment_processor.processor == "fake_processor" and !payment_processor.subscription.nil? and (payment_processor.subscription.trial_ends_at < Time.zone.now)
      template = "expired"
      return template
    end

    template
  end
end
