class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def profile
    @project = Project.first
  end

  def password
    @resource = current_user
  end

  def notifications
  end

  private

  def set_user
    @user = current_user
  end

  
end
