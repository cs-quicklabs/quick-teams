class Employee::AboutController < Employee::BaseController
  before_action :set_employee, only: [:index, :edit, :update, :destroy_observed_project]

  def index
    authorize [@employee, :about]
    @observed_projects = @employee.observed_projects
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

  def destroy_observed_project
    authorize [@employee, :about]
    respond_to do |format|
      if @employee.observed_projects.delete(Project.find(params[:observed_project_id]))
        format.turbo_stream { render turbo_stream: turbo_stream.update("add-observed-projects", partial: "employee/about/observed_projects", locals: { observed_projects: @employee.observed_projects, employee: @employee, message: "Observed project removed successfully" }) }
      end
    end
  end
end
