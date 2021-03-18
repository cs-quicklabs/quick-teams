class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = EventDecorator.decorate_collection(Event.includes(:user).order(created_at: :desc).limit(10))
    fresh_when @events
  end
end
