class Employee::TeamController < Employee::BaseController
  def index
    authorize @employee, :show_team?

    @subordinates = @employee.subordinates.includes(:role, :discipline, :job).order(:first_name)
  end
end
