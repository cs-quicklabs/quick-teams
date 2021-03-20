class PeopleController < ApplicationController
  include Pagy::Backend

  before_action :set_employee, only: %i[ show edit update destroy deactivate_user activate_user ]
  before_action :authenticate_user!

  def index
    @pagy, collection = pagy(User.for_current_account.active.includes(:role, :discipline, :job, :manager, :subordinates).order(:first_name), items: 10)
    @employees = UserDecorator.decorate_collection(collection)
    fresh_when @employees
  end

  def new
    @employee = User.new
  end

  def deactivate_user
    DeactivateUser.call(@employee, current_user)
    redirect_to deactivated_users_path, notice: "User has been deactivated."
  end

  def activate_user
    ActivateUser.call(@employee, current_user)
    redirect_to person_path(@employee), notice: "User has been activated."
  end

  def deactivated
    @employees = UserDecorator.decorate_collection(User.for_current_account.inactive.includes(:role, :discipline, :job).order(deactivated_on: :desc))
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to person_path(@employee), notice: "User was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@employee, partial: "people/forms/form", locals: { employee: @employee }) }
      end
    end
  end

  def create
    employee = CreateUser.call(employee_params, current_user).result
    respond_to do |format|
      if employee.id.nil?
        format.html { redirect_to new_person_path(@user), notice: "Failed to create user. Please try again." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to person_path(employee), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      end
    end
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
