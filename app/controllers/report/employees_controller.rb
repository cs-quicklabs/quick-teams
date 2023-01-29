class Report::EmployeesController < Report::BaseController
  def index
    authorize :report

    entries = User.for_current_account.active.with_attached_avatar.includes(:status).query(employees_filter_params)
    @stats = EmployeesStats.new(entries)

    @pagy, @employees = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/employees/employee", collection: @employees, cached: false)
  end

  private

  def employees_filter_params
    params.permit(*EmployeeFilter::KEYS)
  end
end
