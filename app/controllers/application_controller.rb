class ApplicationController < ActionController::Base
  include Pagy::Backend
  set_current_tenant_through_filter
  before_action :set_tenant

  def set_tenant
    set_current_tenant(Current.account)
  end

  def after_sign_in_path_for(resource)
    set_flash_message! :alert, :warn_pwned if resource.respond_to?(:pwned?) && resource.pwned?
    super
    home_path(script_name: "/#{current_user.account.id}")
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end
end
