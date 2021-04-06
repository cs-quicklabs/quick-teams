class Project::ScheduleController < Project::BaseController
  def index
    collection = Schedule.where(project: @project).includes({ user: [:role, :job] })
    @schedules = ScheduleDecorator.decorate_collection(collection)
    @schedule = Schedule.new
  end
end
