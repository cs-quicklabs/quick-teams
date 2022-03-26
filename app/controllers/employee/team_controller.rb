class Employee::TeamController < Employee::BaseController
  def index
    authorize [@employee, Team]
    @subordinates = @employee.subordinates.includes(:role, :discipline, :job).order(:first_name)
    @managers = @employee.managers.uniq
    fresh_when @subordinates + [@employee]
  end
end
