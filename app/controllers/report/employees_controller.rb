class Report::EmployeesController < Report::BaseController
  def index
    authorize :report

    @pagy, @employees = pagy_nil_safe(User.for_current_account.active.query(employees_filter_params), items: LIMIT)
    render_partial("report/employees/employee", collection: @employees) if stale?(@employees)

  end

  private

  def employees_filter_params
    params.permit(*EmployeeFilter::KEYS)
  end
end
