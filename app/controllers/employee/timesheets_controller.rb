class Employee::TimesheetsController < Employee::BaseController
  before_action :set_timesheet, only: %i[destroy]
  before_action :set_projects, only: %i[create index]

  def index
    authorize @employee

    @timesheet = Timesheet.new
    @timesheets = @employee.timesheets.includes(:project).last_30_days.order(date: :desc)
    @employee_timesheets_stats = EmployeeTimesheetsStats.new(@employee, time_span)

    fresh_when @timesheets
  end

  def create
    authorize [:employee, Timesheet]

    @timesheet = Timesheet.new(timesheet_params)
    @timesheet.user = current_user
    @timesheet.save
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

  def destroy
    authorize [:employee, @timesheet]

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
    @timesheet = Timesheet.find(params["id"])
  end

  def timesheet_params
    params.require(:timesheet).permit(:project_id, :description, :hours, :date, :employee_id)
  end
end
