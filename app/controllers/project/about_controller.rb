class Project::AboutController < Project::BaseController
  def index
    authorize [@project, :about]
    @observers = @project.observers
    fresh_when [@project]
  end

  def edit
    authorize [@project, :about]
  end

  def update
    authorize [@project, :about]
    respond_to do |format|
      if params[:project].present?
        if @project.update("#{params[:project].keys.first}": params[:project].values.first)
          format.html { redirect_to project_about_index_path }
        end
      end
    end
  end
end
