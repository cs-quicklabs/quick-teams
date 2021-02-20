class PeopleController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @employees = UserDecorator.decorate_collection(User.all)
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
  end

  private

  def set_employee
    @employee = User.find(params[:id])
  end

  def employee_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :discipline_id, :job_id)
  end
end
