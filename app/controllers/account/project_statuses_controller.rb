class Account::ProjectStatusesController < Account::BaseController
  before_action :set_project_status, only: %i[ show edit update destroy ]

  # GET /project_statuses or /project_statuses.json
  def index
    @project_statuses = ProjectStatus.all.order(created_at: :desc)
    @project_status = ProjectStatus.new
  end

  # GET /project_statuses/1/edit
  def edit
  end

  # POST /project_statuses or /project_statuses.json
  def create
    @project_status = ProjectStatus.new(project_status_params)

    respond_to do |format|
      if @project_status.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:project_statuses, partial: "account/project_statuses/project_status",
                                                                       locals: { message: "Project Status was created successfully.", project_status: @project_status })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ProjectStatus.new, partial: "account/project_statuses/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /project_statuses/1 or /project_statuses/1.json
  def update
    respond_to do |format|
      if @project_status.update(project_status_params)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@project_status, partial: "account/project_statuses/project_status",
                                                                     locals: { message: "Project Status was created successfully.", project_status: @project_status })
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@project_status, partial: "account/project_statuses/project_status",
                                                                     locals: { project_status: @project_status })
        }
      end
    end
  end

  # DELETE /project_statuses/1 or /project_statuses/1.json
  def destroy
    @project_status.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@project_status) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_status
    @project_status = ProjectStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_status_params
    params.require(:project_status).permit(:name, :account_id)
  end
end
