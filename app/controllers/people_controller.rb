class PeopleController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy deactivate_user activate_user ]
  before_action :authenticate_user!

  def index
    @employees = UserDecorator.decorate_collection(User.for_current_account.active.includes(:role, :discipline, :job, :manager, :subordinates).order(:first_name))
  end

  def new
    @employee = User.new
  end

  def deactivate_user
    DeactivateUser.call(@employee)
    redirect_to deactivated_users_path, notice: "User has been deactivated."
  end

  def activate_user
    ActivateUser.call(@employee)
    redirect_to person_path(@employee), notice: "User has been activated."
  end

  def deactivated
    @employees = UserDecorator.decorate_collection(User.for_current_account.inactive.includes(:role, :discipline, :job).order(deactivated_on: :desc))
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to people_path, notice: "User was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@employee, partial: "people/forms/form", locals: { employee: @employee }) }
      end
    end
  end

  def create
  end

  def show
    @employee = @employee.decorate
    redirect_to person_team_path(@employee)
  end

  private

  def set_employee
    @employee = User.find(params[:id])
  end

  def employee_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :discipline_id, :job_id, :manager_id)
  end
end
