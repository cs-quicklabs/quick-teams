class Employee::TimelineController < Employee::BaseController
  def index
    authorize @employee, :show_timeline?

    collection = []
    if @employee.id == current_user.id # do not show what I am doing
      collection = Event.where(eventable: @employee).or(Event.where(trackable: @employee)).order(created_at: :desc)
    else
      collection = Event.where(user: @employee).or(Event.where(eventable: @employee)).or(Event.where(trackable: @employee)).order(created_at: :desc)
    end
    @events = collection.includes(:eventable, :trackable, :user).decorate
    fresh_when @events
  end
end
