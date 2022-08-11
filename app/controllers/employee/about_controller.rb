class Employee::AboutController < Employee::BaseController
  before_action :set_employee, only: [:index, :edit, :update]

  def index
    authorize [@employee, :about]
    fresh_when [@employee]
  end

  def edit
    authorize [@employee, :about]
  end

  def update
    authorize [@employee, :about]
    respond_to do |format|
      if params[:user].present?
        if @employee.update("#{params[:user].keys.first}": params[:user].values.first)
          format.html { redirect_to employee_about_index_path }
        end
      end
    end
  end
end
