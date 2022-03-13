class Purchase::BillingsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer
    @portal = current_user.payment_processor.billing_portal(return_url: root_url + "home")
    redirect_to @portal.url, allow_other_host: true
  end
end
