class Project::TimelineController < Project::BaseController
  def index
    authorize [:project, :timeline]
    collection = Event.where(trackable: @project).or(Event.where(eventable: @project)).order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(collection.includes(:eventable, :trackable, :user), items: LIMIT)
    @events = events_collection.decorate
 	respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: @events.actions, formats: [:html], locals: {event: @events}, cached: true),
        pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end
end
