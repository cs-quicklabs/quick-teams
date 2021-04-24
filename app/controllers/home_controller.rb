class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize :home
    @events = Event.includes(:user, :eventable, :trackable).order(created_at: :desc).limit(10)
    fresh_when @events
  end
end
