class Purchase::CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.set_payment_processor :stripe
    price = params[:price_id]
    session = current_user.payment_processor.checkout(
      client_reference_id: current_user.id,
      success_url: root_url + "success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: home_url(script_name: "/#{current_user.account.id}"),
      payment_method_types: ["card"],
      mode: "subscription",
      line_items: [{
        quantity: 1,
        price: price,
      }],
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(session.customer)
  end
end
