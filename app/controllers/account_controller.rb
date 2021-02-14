class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@account, partial: "accounts/forms/profile", locals: { message: "Account was updated successfully", account: @account }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@account, partial: "accounts/forms/profile", locals: { account: @account }) }
      end
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name)
  end
end
