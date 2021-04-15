class Employee::TimesheetsController < Employee::BaseController
  def index
    @timesheets = @employee.timesheets.order(date: :desc)
    @timesheet = Timesheet.new

    @title = @employee.active ? "Last Week's Performance" : "Performance since beginning"
    time_span = @employee.active ? "week" : "beginning"
    @stats = EmployeeTimesheetsStats.new(@employee, time_span)
  end

  def create
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

  private

  def timesheet_params
    params.require(:timesheet).permit(:project_id, :description, :value, :date, :employee_id)
  end
end
