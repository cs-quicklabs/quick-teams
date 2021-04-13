class Employee::TimesheetsController < Employee::BaseController
  def index
    @timesheets = Timesheet.all
    @timesheet = Timesheet.new
  end

  def create
    @timesheet = Timesheet.new(timesheet_params)
    @timesheet.user = current_user
    @timesheet.save
    respond_to do |format|
      if @timesheet.persisted?
        @timesheet = Timesheet.new
        format.html { redirect_to employee_timesheets_path(@employee), notice: "Timesheet was added successfully." }
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
