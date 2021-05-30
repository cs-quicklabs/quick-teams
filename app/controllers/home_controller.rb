class HomeController < BaseController
  def index
    authorize :home
  end

  def goals
    authorize :home, :index?

    @goals = Goal.window_90_days.order(status: :asc).order(deadline: :asc).limit(40)
  end

  def events
    authorize :home, :index?

    @events = Event.includes(:user, :eventable, :trackable).order(created_at: :desc).limit(50).decorate
  end
end
