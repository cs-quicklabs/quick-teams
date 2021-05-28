class Report::EmployeesController < Report::BaseController
  def index
    authorize :report

    entries = User.for_current_account.active.query(employees_filter_params)
    @stats = EmployeesStats.new(entries)

    @pagy, @employees = pagy_nil_safe(entries, items: LIMIT)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "report/employees/employee", formats: [:html], collection: @employees, cached: true),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  private

  def employees_filter_params
    params.permit(*EmployeeFilter::KEYS)
  end
end
