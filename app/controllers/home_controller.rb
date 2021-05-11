class HomeController < BaseController
  before_action :authenticate_user!

  def index
    authorize :home

    @limit = 50
    @events = Event.includes(:user, :eventable, :trackable).order(created_at: :desc).limit(@limit).decorate
    @goals = Goal.window_90_days.order(deadline: :asc).limit(@limit)

    fresh_when @events + @goals
  end
end
