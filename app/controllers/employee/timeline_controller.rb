class Employee::TimelineController < Employee::BaseController
  def index
    authorize @employee, :show_timeline?

    collection = []
    if @employee.id == current_user.id # do not show what I am doing
      collection = Event.where(eventable: @employee).or(Event.where(trackable: @employee)).order(created_at: :desc)
    else
      collection = Event.where(user: @employee).or(Event.where(eventable: @employee)).or(Event.where(trackable: @employee)).order(created_at: :desc)
    end
    @pagy, events_collection = pagy_nil_safe(collection.includes(:eventable, :trackable, :user), items: LIMIT)
    @events = events_collection.decorate
    render_timeline("employee/timeline/activity", collection: @events) if stale?(@events  + [@employee])
  end
end
