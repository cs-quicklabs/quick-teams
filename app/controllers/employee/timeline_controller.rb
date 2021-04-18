class Employee::TimelineController < Employee::BaseController
  def index
    collection = Event.where(user: @employee).or(Event.where(eventable: @employee)).order(created_at: :desc)
    @events = EventDecorator.decorate_collection(collection)
    fresh_when @events
  end
end
