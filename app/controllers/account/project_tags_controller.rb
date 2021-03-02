class Account::ProjectTagsController < Account::BaseController
  before_action :set_project_tag, only: %i[ show edit update destroy ]

  # GET /project_tags or /project_tags.json
  def index
    @project_tags = ProjectTag.all
    @project_tag = ProjectTag.new
  end

  # GET /project_tags/1/edit
  def edit
  end

  # POST /project_tags or /project_tags.json
  def create
    @project_tag = ProjectTag.new(project_tag_params)

    respond_to do |format|
      if @project_tag.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:project_tags, partial: "account/project_tags/project_tag",
                                                                   locals: { message: "Tag was created successfully.", project_tag: @project_tag })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ProjectTag.new, partial: "account/project_tags/form", locals: {}) }
      end
    end
  end

  # PATCH/PUT /project_tags/1 or /project_tags/1.json
  def update
    respond_to do |format|
      if @project_tag.update(project_tag_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project_tag, partial: "account/project_tags/project_tag", locals: { message: "Tag was created successfully.", project_tag: @project_tag }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project_tag, partial: "account/project_tags/project_tag", locals: { project_tag: @project_tag }) }
      end
    end
  end

  # DELETE /project_tags/1 or /project_tags/1.json
  def destroy
    @project_tag.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@project_tag) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_tag
    @project_tag = ProjectTag.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_tag_params
    params.require(:project_tag).permit(:name, :account_id)
  end
end
