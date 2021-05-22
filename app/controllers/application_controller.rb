class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token

  etag { heroku_version }

  fragment_cache_key do
    current_user.permission
  end

  def heroku_version
    ENV["HEROKU_RELEASE_VERSION"] if Rails.env == "production" or Rails.env == "staging"
  end

  def after_sign_in_path_for(resource)
    landing_path
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end

  def user_not_authorized
    redirect_to(request.referrer || landing_path)
  end

  def signed_in_root_path(resource)
    landing_path
  end

  def record_not_found
    user_not_authorized
  end

  def invalid_token
    sign_out(current_user) if current_user
    redirect_to new_user_session_path, alert: "Your session has expired. Please login again."
  end

  def landing_path
    if current_user.admin?
      home_path(script_name: script_name)
    elsif current_user.lead?
      employee_team_path(current_user, script_name: script_name)
    elsif current_user.member?
      employee_schedules_path(current_user, script_name: script_name)
    else
      root_path(script_name: "")
    end
  end

  def script_name
    "/#{current_user.account.id}"
  end
end
