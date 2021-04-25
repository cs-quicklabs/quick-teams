class Project::TimelineController < Project::BaseController
  def index
    @events = @project.events.includes(:user, :eventable, :trackable).order(created_at: :desc).decorate
    fresh_when @events
  end
end
