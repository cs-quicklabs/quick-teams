class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  before_action :set_tenant

  def set_tenant
    current_account = Account.find(1)
    set_current_tenant(current_account)
  end

  def after_sign_in_path_for(resource)
    home_path
  end
end
