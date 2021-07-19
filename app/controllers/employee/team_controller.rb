class Employee::TeamController < Employee::BaseController
  def index
    authorize @employee

    @subordinates = @employee.subordinates.includes(:role, :discipline, :job).order(:first_name)
    fresh_when @subordinates + [@employee]
  end
end
