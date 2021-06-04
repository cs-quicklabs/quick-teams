class Account::PreferencesController < Account::BaseController
  before_action :set_account

  def index
    authorize :account
  end

  private

  def set_account
    @account ||= current_user.account
  end
end
