class Project::TimelineController < Project::BaseController
  def index
    authorize [:project, :timeline]
    collection = Event.where(trackable: @project).or(Event.where(eventable: @project)).order(created_at: :desc).limit(100)
    @events = collection.includes(:eventable, :trackable, :user).decorate
    fresh_when @events
  end
end
