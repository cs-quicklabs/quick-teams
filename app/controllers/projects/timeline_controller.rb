class Projects::TimelineController < Projects::BaseController
  before_action :authenticate_user!

  def index
    @events = EventDecorator.decorate_collection(@project.events.includes(:user).order(created_at: :desc))
  end
end
