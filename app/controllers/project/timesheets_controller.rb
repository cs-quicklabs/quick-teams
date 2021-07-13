class Project::TimesheetsController < Project::BaseController
  def index
    authorize [@project, Timesheet]

    @project_timesheets_stats = ProjectTimesheetsStats.new(@project, "week")
    @pagy, collection = pagy_nil_safe(@project.timesheets.last_30_days.includes(:user).order(date: :desc), items: LIMIT)
    @timesheets = collection.decorate

    render_partial("project/timesheets/timesheet", collection: @timesheets) if stale?(@timesheets + [@project])
  end
end
