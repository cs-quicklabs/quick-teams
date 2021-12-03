class Employee::TimesheetsController < Employee::BaseController
  before_action :set_timesheet, only: %i[destroy edit update]
  before_action :set_projects, only: %i[create index edit]

  def index
    authorize [@employee, Timesheet]

    @timesheet = Timesheet.new
    @employee_timesheets_stats = EmployeeTimesheetsStats.new(@employee, time_span)
    @pagy, @timesheets = pagy_nil_safe(params, @employee.timesheets.includes(:project).last_30_days.order(date: :desc), items: LIMIT)
    render_partial("employee/timesheets/timesheet", collection: @timesheets) if stale?(@timesheets + [@employee])
  end

  def create
    authorize [@employee, Timesheet]

    @timesheet = AddTimesheet.call(timesheet_params, current_user).result

    respond_to do |format|
      if @timesheet.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(Timesheet.new, partial: "employee/timesheets/form", locals: { timesheet: Timesheet.new, projects: @projects, message: "Timesheet was added successfully." }) +
                               turbo_stream.prepend(:timesheets, partial: "employee/timesheets/timesheet", locals: { timesheet: @timesheet })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Timesheet.new, partial: "employee/timesheets/form", locals: { timesheet: @timesheet, projects: @projects }) }
      end
    end
  end
  def edit
    authorize [@employee, @timesheet]
  end
 def update
    authorize [@employee, @timesheet]

    respond_to do |format|
      if @timesheet.update(timesheet_params)
         format.html { redirect_to employee_timesheets_path(@employee), notice: "Timesheet was successfully updated." }
      else
        format.html { redirect_to edit_employee_timesheet_path(@employee), alert: "Failed to update. Please try again." }
    end
  end
  end
  def destroy
    authorize [@employee, @timesheet]

    @timesheet.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@timesheet) }
    end
  end

  private

  def set_projects
    @projects ||= @employee.projects.order(:name)
  end

  def time_span
    @employee.active ? "month" : "beginning"
  end

  def set_timesheet
    @timesheet ||= Timesheet.find(params["id"])
  end

  def timesheet_params
    params.require(:timesheet).permit(:project_id, :description, :hours, :date, :employee_id)
  end
end
