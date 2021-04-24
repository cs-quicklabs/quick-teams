class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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

  def record_not_found
    user_not_authorized
  end

  def landing_path
    if current_user.member?
      employee_schedules_path(current_user, script_name: "/#{current_user.account.id}")
    else
      employee_team_path(current_user, script_name: "/#{current_user.account.id}")
    end
  end
end
