class Project::TimesheetsController < Project::BaseController
  def index
    collection = @project.timesheets.includes(:user).order(date: :desc)
    @timesheets = TimesheetDecorator.decorate_collection(collection)

    @stats = ProjectTimesheetsStats.new(@project, "week")

    fresh_when @timesheets
  end
end
