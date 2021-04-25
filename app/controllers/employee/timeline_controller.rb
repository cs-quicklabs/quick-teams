class Employee::TimelineController < Employee::BaseController
  def index
    authorize [:employee, :timeline]

    collection = Event.where(user: @employee).or(Event.where(eventable: @employee)).order(created_at: :desc)
    @events = EventDecorator.decorate_collection(collection.includes(:eventable, { trackable: :user }, :user))
    fresh_when @events
  end
end
