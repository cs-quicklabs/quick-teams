class Report::RolesController < Report::BaseController
  def index
    authorize :report
    entries = User.for_current_account.active.includes(:status).query(employee_filter_params)

    @pagy, @employees = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/roles/employee", collection: @employees, cached: false)
  end

  private

  def employee_filter_params
    params.permit(*EmployeeFilter::KEYS)
  end
end
