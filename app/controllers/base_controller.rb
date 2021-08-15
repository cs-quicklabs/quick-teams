class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_account!
  after_action :verify_authorized

  def authenticate_account!
    raise Pundit::NotAuthorizedError unless current_user.account == Current.account
  end
end
