class HomeController < BaseController
  before_action :authenticate_user!

  def index
    authorize :home

    @events = Event.includes(:user, :eventable, :trackable).order(created_at: :desc).limit(20).decorate
    @goals = Goal.window_90_days.order(updated_at: :desc).limit(20)

    fresh_when @events + @goals
  end
end
