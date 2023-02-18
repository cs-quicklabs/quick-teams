class HomeController < BaseController
  def index
    authorize :home
  end

  def goals
    authorize :home, :index?

    @goals = Goal.next_90_days.includes(:user, :goalable).order(status: :asc).order(deadline: :asc).limit(40)
  end

  def events
    authorize :home, :index?

    @events = Event.includes(:eventable, :trackable, :user => { avatar_attachment: :blob }).order(created_at: :desc).limit(50).decorate
  end
end
