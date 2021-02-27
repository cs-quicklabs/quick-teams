class Projects::ScheduleController < Projects::BaseController
  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.where(project: @project))
    @schedule = Schedule.new
  end
end
