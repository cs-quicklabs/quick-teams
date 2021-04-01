class Project::ScheduleController < Project::BaseController
  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.where(project: @project).includes({ user: [:role, :job] }))
    @schedule = Schedule.new
  end
end
