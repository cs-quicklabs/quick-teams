class Employee::TimelineController < Employee::BaseController
  def index
    authorize [:employee, :timeline]

    @events = Event.where(user: @employee).or(Event.where(eventable: @employee)).order(created_at: :desc)
    fresh_when @events
  end
end
