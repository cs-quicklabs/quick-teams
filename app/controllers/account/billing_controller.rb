class Account::BillingController < Account::BaseController
  before_action :authenticate_user!

  def index
    authorize :account, :billings?

    state = get_state
    @template = get_template(state)
  end

  private

  def get_state
    "a"
  end

  def get_template(state)
    "manage"
  end
end
