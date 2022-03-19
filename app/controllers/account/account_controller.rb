class Account::AccountController < Account::BaseController
  before_action :set_account

  def index
    authorize :account, :account?
  end

  def update
    authorize :account

    respond_to do |format|
      if @account.update(account_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@account, partial: "account/account/form", locals: { message: "Account was updated successfully", account: @account }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@account, partial: "account/account/form", locals: { account: @account }) }
      end
    end
  end

  private

  def set_account
    @account ||= Account.find(current_user.account_id)
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
