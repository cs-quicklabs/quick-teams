class Employee::TimelineController < Employee::BaseController
  def index
    authorize @employee, :show_timeline?

    collection = Event.where(user: @employee).or(Event.where(eventable: @employee)).order(created_at: :desc)
    @events = collection.includes(:eventable, :trackable, :user).decorate
    fresh_when @events
  end
end
