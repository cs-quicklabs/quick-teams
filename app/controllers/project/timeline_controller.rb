class Project::TimelineController < Project::BaseController
  before_action :authenticate_user!

  def index
    @events = EventDecorator.decorate_collection(@project.events.includes(:user, :eventable, :trackable).order(created_at: :desc))
    fresh_when @events
  end
end
