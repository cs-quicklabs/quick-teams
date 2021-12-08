class Project::TimesheetsController < Project::BaseController
  before_action :set_timesheet, only: %i[destroy edit update]
  before_action :set_projects, only: %i[create index edit]

  def index
    authorize [@project, Timesheet]

    @project_timesheets_stats = ProjectTimesheetsStats.new(@project, "week")
    @pagy, collection = pagy_nil_safe(params, @project.timesheets.last_30_days.includes(:user).order(date: :desc), items: LIMIT)
    @timesheets = collection.decorate

    render_partial("project/timesheets/timesheet", collection: @timesheets) if stale?(@timesheets + [@project])
  end

  def edit
    authorize [@project, @timesheet]
  end

  def update
    authorize [@project, @timesheet]

    respond_to do |format|
      if @timesheet.update(timesheet_params)
        format.html { redirect_to project_timesheets_path(@project), notice: "Timesheet was successfully updated." }
      else
        format.html { redirect_to edit_project_timesheet_path(@project), alert: "Failed to update. Please try again." }
      end
    end
  end

  def destroy
    authorize [@project, @timesheet]

    @timesheet.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@timesheet) }
    end
  end

  private

  def set_projects
    @projects ||= current_user.managed_projects.order(:name)
  end

  def set_timesheet
    @timesheet ||= Timesheet.find(params["id"])
  end

  def timesheet_params
    params.require(:timesheet).permit(:project_id, :description, :hours, :date, :project_id)
  end
end
