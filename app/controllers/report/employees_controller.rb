class Report::EmployeesController < Report::BaseController
  def index
    authorize :team

    @employees = User.query(employees_filter_params)
    fresh_when @employees
  end

  private

  def employees_filter_params
    params.permit(*EmployeeFilter::KEYS)
  end
end
