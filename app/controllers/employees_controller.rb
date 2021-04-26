class EmployeesController < BaseController
  include Pagy::Backend

  before_action :set_employee, only: %i[ show edit update destroy deactivate_user activate_user ]
  before_action :authenticate_user!
  before_action :build_form, only: %i[create]

  def index
    authorize :team

    @pagy, @employees = pagy(User.for_current_account.active.includes(:role, :discipline, :job, :manager, :subordinates).order(:first_name), items: 10)
    fresh_when @employees
  end

  def new
    authorize :team

    @employee = User.new
  end

  def update
    authorize :team

    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_path(@employee), notice: "User was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@employee, partial: "employees/forms/form", locals: { employee: @employee }) }
      end
    end
  end

  def create
    authorize :team

    employee = @form.submit(employee_params)
    respond_to do |format|
      if !employee
        format.html { redirect_to new_employee_path(@user), alert: "Failed to create user. Please try again." }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to employee_path(employee), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      end
    end
  end

  def show
    authorize @employee

    redirect_to employee_team_path(@employee)
  end

  def deactivate_user
    DeactivateUser.call(@employee, current_user)
    redirect_to deactivated_users_path, notice: "User has been deactivated."
  end

  def activate_user
    ActivateUser.call(@employee, current_user)
    redirect_to employee_path(@employee), notice: "User has been activated."
  end

  def deactivated
    @employees = User.for_current_account.inactive.includes(:role, :discipline, :job).order(deactivated_on: :desc)
  end

  private

  def set_employee
    @employee ||= User.find(params[:id])
  end

  def employee_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :discipline_id, :job_id, :manager_id)
  end

  def build_form
    @form ||= CreateUserForm.new(Current.account, current_user)
  end
end
