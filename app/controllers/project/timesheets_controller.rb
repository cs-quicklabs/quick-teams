class Project::TimesheetsController < Project::BaseController
  def index
    @timesheets = @project.timesheets.last_30_days.includes(:user).order(date: :desc).decorate
    @stats = ProjectTimesheetsStats.new(@project, "week")

    fresh_when @timesheets
  end
end
