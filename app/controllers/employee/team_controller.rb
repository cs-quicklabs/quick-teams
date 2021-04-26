class Employee::TeamController < Employee::BaseController
  def index
    authorize @employee

    @subordinates = @employee.subordinates.includes(:role, :discipline, :job)
  end
end
