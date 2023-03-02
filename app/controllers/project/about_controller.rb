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

  def destroy_observer
    authorize [@project, :about]
    @observer = User.find(params[:observer_id])
    @project = RemoveObserver.call(@project, @observer, current_user).result
    respond_to do |format|
      if @project.errors.empty?
        format.turbo_stream { render turbo_stream: turbo_stream.update("add-observers", partial: "project/about/observer", locals: { observers: @project.observers, project: @project, message: "Observer removed successfully" }) }
      end
    end
  end
end
