class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_details_path, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { redirect_to account_details_path, notice: "Account failed updated." }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:name)
  end
end
