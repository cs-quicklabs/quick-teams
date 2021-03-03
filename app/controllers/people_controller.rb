class PeopleController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
   @pagy, @employees = pagy_countless(UserDecorator.decorate_collection(User.for_current_account.includes(:role, :discipline, :job, :manager, :subordinates).order(:first_name)))
  end

  def new
    @employee = User.new
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
