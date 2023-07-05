class EmployeesController < BaseController
  include Pagy::Backend

  before_action :set_employee, only: %i[ show edit update destroy deactivate_user activate_user ]
  before_action :build_form, only: %i[create]

  def index
    authorize :team

    @pagy, @employees = pagy(User.with_attached_avatar.for_current_account.active.includes(:role, :discipline, :job, :manager, :subordinates, :status).order(:first_name), items: 10)

    fresh_when @employees
  end

  def new
    authorize :team

    @employee = User.new
  end

  def edit
    authorize :team
  end

  def update
    authorize :team
    @employee = UpdateEmployee.call(@employee, employee_params, current_user).result
    respond_to do |format|
      if @employee.errors.empty?
        format.html { redirect_to employee_team_path(@employee), notice: "User was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@employee, partial: "employees/forms/form", locals: { employee: @employee }) }
      end
    end
  end

  def create
    authorize :team

    employee = @form.submit(employee_params, params[:invite])

    respond_to do |format|
      if employee.persisted?
        format.html { redirect_to employee_team_path(employee), notice: "User was successfully created." }
      else
        format.html { redirect_to new_employee_path(@user), alert: "Failed to create user. Please try again." }
      end
    end
  end

  def show
    authorize @employee

    redirect_to employee_team_path(@employee)
  end

  def destroy
    authorize :team

    respond_to do |format|
      if DestroyUser.call(@employee).result
        format.turbo_stream { redirect_to deactivated_users_path, status: 303, notice: "User has been deleted." }
      else
        format.turbo_stream { redirect_to deactivated_users_path, status: 303, alert: "Failed to delete user." }
      end
    end
  end

  private

  def set_employee
    @employee ||= User.find(params[:id])
  end

  def employee_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :discipline_id, :job_id, :manager_id, :billable, :permission)
  end

  def build_form
    @form ||= CreateUserForm.new(Current.account, current_user)
  end
end
