class Employee::KpisController < Employee::BaseController
  def index
    authorize [@employee, :kpi]
    @kpi = @employee.kpi
    @stats = EmployeeKpisStats.new(@employee, @kpi) unless @kpi.nil?
  end
end
