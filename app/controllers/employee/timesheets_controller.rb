class Employee::TimesheetsController < Employee::BaseController
  before_action :set_timesheet, only: %i[destroy]

  def index
    authorize [:employee, Timesheet]

    @timesheets = @employee.timesheets.last_30_days.order(date: :desc)
    @timesheet = Timesheet.new

    time_span = @employee.active ? "week" : "beginning"
    @employee_timesheets_stats = EmployeeTimesheetsStats.new(@employee, time_span)
  end

  def create
    authorize [:employee, Timesheet]

    @timesheet = Timesheet.new(timesheet_params)
    @timesheet.user = current_user
    @timesheet.save
    respond_to do |format|
      if @timesheet.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(Timesheet.new, partial: "employee/timesheets/form", locals: { timesheet: Timesheet.new, message: "Timesheet was added successfully." }) +
                               turbo_stream.prepend(:timesheets, partial: "employee/timesheets/timesheet", locals: { timesheet: @timesheet })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Timesheet.new, partial: "employee/timesheets/form", locals: { timesheet: @timesheet }) }
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

  def set_timesheet
    @timesheet = Timesheet.find(params["id"])
  end

  def timesheet_params
    params.require(:timesheet).permit(:project_id, :description, :hours, :date, :employee_id)
  end
end
