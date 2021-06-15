class Project::TimelineController < Project::BaseController
  def index
    authorize [:project, :timeline]
    collection = Event.where(trackable: @project).or(Event.where(eventable: @project)).order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(collection.includes(:eventable, :trackable, :user), items: LIMIT)
    @events = events_collection.decorate
    render_timeline("project/timeline/activity", collection: @events) if stale?(@events + [@project])
  end
end
