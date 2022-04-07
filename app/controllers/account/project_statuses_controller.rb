class Account::ProjectStatusesController < Account::BaseController
  before_action :set_project_status, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @project_statuses = ProjectStatus.all.order(:name).order(created_at: :desc)
    @project_status = ProjectStatus.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @project_status = ProjectStatus.new(project_status_params)

    respond_to do |format|
      if @project_status.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:project_statuses, partial: "account/project_statuses/project_status", locals: { project_status: @project_status }) +
                               turbo_stream.replace(ProjectStatus.new, partial: "account/project_statuses/form", locals: { project_status: ProjectStatus.new, message: "Project Status was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ProjectStatus.new, partial: "account/project_statuses/form", locals: { project_status: @project_status }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @project_status.update(project_status_params)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@project_status, partial: "account/project_statuses/project_status",
                                                                     locals: { project_status: @project_status, message: nil })
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@project_status, template: "account/project_statuses/edit",
                                                                     locals: { project_status: @project_status, messages: @project_status.errors.full_messages })
        }
      end
    end
  end

  def destroy
    authorize :account

    @project_status.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@project_status) }
    end
  end

  private

  def set_project_status
    @project_status ||= ProjectStatus.find(params[:id])
  end

  def project_status_params
    params.require(:project_status).permit(:name, :account_id, :color)
  end
end
