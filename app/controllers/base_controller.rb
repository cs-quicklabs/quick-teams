class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_account
  after_action :verify_authorized

  def authenticate_account
    if current_user.account != Current.account
      sign_out current_user
      redirect_to root_path(script_name: "")
    end
  end
end
