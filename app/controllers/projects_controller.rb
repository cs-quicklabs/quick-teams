class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy archive_project unarchive_project ]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    @projects = ProjectDecorator.decorate_collection(Project.active.includes(:discipline, :participants, :manager).order(:name))
    fresh_when @projects
  end

  # GET /projects/1 or /projects/1.json
  def show
    redirect_to project_participants_path(@project)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Project.new, partial: "projects/forms/form", locals: { project: @project, title: "Create New Project", subtitle: "Please fill in the details of you new Project." }) }
      end
    end
  end

  def archived
    @projects = ProjectDecorator.decorate_collection(Project.archived.includes(:discipline).order(archived_on: :desc))
  end

  def archive_project
    ArchiveProject.call(@project, current_user)
    redirect_to archived_projects_path, notice: "Project has been archived."
  end

  def unarchive_project
    UnarchiveProject.call(@project, current_user)
    redirect_to project_participants_path(@project), notice: "Project has been restored."
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project, partial: "projects/forms/form", locals: { project: @project, title: "Edit Project", subtitle: "Please update details of existing project" }) }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :discipline_id, :manager_id)
  end
end
