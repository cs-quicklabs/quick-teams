class ProjectsController < BaseController
  before_action :set_project, only: %i[ show edit update destroy archive_project unarchive_project ]

  def index
    authorize :projects

    @projects = policy_scope(Project)
    fresh_when @projects
  end

  def show
    authorize @project

    redirect_to project_schedules_path(@project)
  end

  def new
    authorize :projects

    @project = Project.new
    @project.billable = true
  end

  def edit
    authorize :projects
  end

  def create
    authorize :projects

    @project = CreateProject.call(project_params, current_user).result

    respond_to do |format|
      if @project.errors.empty?
        format.html { redirect_to @project, notice: "Project was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Project.new, partial: "projects/forms/form", locals: { project: @project, title: "Create New Project", subtitle: "Please fill in the details of you new Project." }) }
      end
    end
  end

  def update
    authorize :projects

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project, partial: "projects/forms/form", locals: { project: @project, title: "Edit Project", subtitle: "Please update details of existing project" }) }
      end
    end
  end

  def destroy
    authorize :projects

    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def archived
    authorize :projects, :index?

    @projects = Project.archived.includes(:discipline).order(archived_on: :desc)
  end

  def archive_project
    authorize :projects, :update?

    ArchiveProject.call(@project, current_user)
    redirect_to archived_projects_path, notice: "Project has been archived."
  end

  def unarchive_project
    authorize :projects, :update?

    UnarchiveProject.call(@project, current_user)
    redirect_to project_schedules_path(@project), notice: "Project has been restored."
  end

  private

  def set_project
    @project ||= Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :discipline_id, :manager_id, :billable, :billable_resources)
  end
end
