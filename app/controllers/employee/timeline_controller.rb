class Employee::TimelineController < Employee::BaseController
  before_action :authenticate_user!

  def index
    @events = EventDecorator.decorate_collection(@employee.events.includes(:user, :eventable, :trackable).order(created_at: :desc))
    fresh_when @events
  end
end
