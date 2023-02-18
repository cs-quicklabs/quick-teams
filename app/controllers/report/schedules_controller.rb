class Report::SchedulesController < Report::BaseController
  include CsvHelper

  def available
    authorize :report, :index?

    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:job_id).decorate
    @employees = @employees.select { |e| e.overall_occupancy < 100 }

    respond_to do |format|
      format.html { fresh_when @employees }
      format.csv { send_data to_csv(@employees), filename: "available_resources_#{Date.today}.csv" }
    end
  end

  def no_schedule
    authorize :report, :index?

    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:job_id).decorate
    @employees = @employees.select { |e| e.overall_occupancy == 0 }

    respond_to do |format|
      format.html { fresh_when @employees }
      format.csv { send_data to_csv(@employees), filename: "no_schedule_#{Date.today}.csv" }
    end
  end

  def overburdened
    authorize :report, :index?
    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:first_name).decorate
    @employees = @employees.select { |e| e.overall_occupancy > 100 }

    respond_to do |format|
      format.html { fresh_when @employees }
      format.csv { send_data to_csv(@employees), filename: "overburdened_resources_#{Date.today}.csv" }
    end
  end

  def shared
    authorize :report, :index?
    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:first_name).decorate
    @employees = @employees.select { |e| e.schedules.size > 1 }

    respond_to do |format|
      format.html { fresh_when @employees }
      format.csv { send_data to_csv(@employees), filename: "shared_resources_#{Date.today}.csv" }
    end
  end

  def no_projects
    authorize :report, :index?

    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:job_id).decorate
    @employees = @employees.select { |e| e.schedules.empty? && e.billable }

    @pagy, @employees = pagy_nil_safe(params, @employees, items: LIMIT)

    respond_to do |format|
      format.html { fresh_when @employees }
      format.csv { send_data to_csv_short(@employees), filename: "no_projects_#{Date.today}.csv" }
    end
  end

  def available_next_month
    authorize :report, :index?
    @employees = User.with_attached_avatar.for_current_account.active.billable.includes({ schedules: :project }, :role, :discipline, :job, :status).order(:job_id).decorate
    @employees = @employees.select { |e| schedule_not_planned_after_month(e) }
  end

  def schedule_not_planned_after_month(employee)
    authorize :report, :index?
    return false if employee.schedules.size == 0 or employee.overall_occupancy < 60 #selected occupied resources only
    planned_till = employee.schedules.try(:maximum, :ends_at)
    return true if planned_till.nil?

    planned_till < Date.today + 30.days
  end

  def roles
    authorize :report, :index?

    @employees = User.with_attached_avatar.for_current_account.active.includes(:status).query(employee_filter_params)
    @stats = EmployeesStats.new(@employees)

    @pagy, @employees = pagy_nil_safe(params, @employees, items: LIMIT)

    render_partial_as("report/schedules/schedule", collection: @employees, as: :employee, cached: false)
  end

  private

  def employee_filter_params
    params.except(:commit).permit(*EmployeeFilter::KEYS)
  end
end
