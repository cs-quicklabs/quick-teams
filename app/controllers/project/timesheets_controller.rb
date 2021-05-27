class Project::TimesheetsController < Project::BaseController
  def index
    authorize :project

    @project_timesheets_stats = ProjectTimesheetsStats.new(@project, "week")
    @pagy, collection =  pagy_nil_safe(@project.timesheets.last_30_days.includes(:user).order(date: :desc), items: LIMIT)
    @timesheets = collection.decorate
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "project/timesheets/timesheet", formats: [:html], collection: @timesheets, cached: true),
        pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end
end
