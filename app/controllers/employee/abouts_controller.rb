class Employee::AboutsController < Employee::BaseController
  before_action :set_employee, only: [:index, :edit_employee, :update_employee_about]

  def index
    authorize [@employee, :about]
  end

  def edit_employee
    authorize [@employee, :about]
    @fields = ["experience", "about", "cv"]
  end

  def update_employee_about
    authorize [@employee, :about]
    respond_to do |format|
      if params[:user].present?
        if @employee.update("#{params[:user].keys.first}": params[:user].values.first)
          format.html { redirect_to employee_abouts_path }
        end
      end
    end
  end
end
