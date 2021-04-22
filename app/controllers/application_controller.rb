class ApplicationController < ActionController::Base
  include Pundit
  #after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if current_user.admin?
      home_path(script_name: "/#{current_user.account.id}")
    else
      landing_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end

  def user_not_authorized
    redirect_to(request.referrer || landing_path)
  end

  def landing_path
    employee_schedules_path(current_user, script_name: "/#{current_user.account.id}")
  end
end
