class Employee::TeamController < Employee::BaseController
  def index
    authorize [:employee, :team]

    @subordinates = UserDecorator.decorate_collection(@employee.subordinates.includes(:role, :discipline, :job))
  end
end
