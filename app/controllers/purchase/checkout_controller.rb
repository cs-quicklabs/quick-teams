class Purchase::CheckoutController < ApplicationController
  before_action :authenticate_user!

  def show
    #current_user.set_payment_processor :stripe
    #current_user.payment_processor.subscribe(name: "default", plan: "price_1K3CeISHKnzorIjUObjrfM2i", trial_period_days: 14)
  end
end
