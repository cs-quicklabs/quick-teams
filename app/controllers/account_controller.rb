class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_details_path, notice: "Account was successfully updated." }
      else
        format.html { redirect_to account_details_path, alert: "Failed to update account." }
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
