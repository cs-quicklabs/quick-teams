class Project::TimesheetsController < Project::BaseController
  def index
    @timesheets = @project.timesheets.includes(:user).order(date: :desc)
  end
end
