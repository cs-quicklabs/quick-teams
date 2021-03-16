class ApplicationController < ActionController::Base
	include Pagy::Backend

  def after_sign_in_path_for(resource)
    home_path(script_name: "/#{current_user.account.id}")
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end
end
