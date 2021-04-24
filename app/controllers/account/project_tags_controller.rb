class Account::ProjectTagsController < Account::BaseController
  before_action :set_project_tag, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @project_tags = ProjectTag.all.order(created_at: :desc)
    @project_tag = ProjectTag.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @project_tag = ProjectTag.new(project_tag_params)

    respond_to do |format|
      if @project_tag.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:project_tags, partial: "account/project_tags/project_tag", locals: { project_tag: @project_tag }) +
                               turbo_stream.replace(ProjectTag.new, partial: "account/project_tags/form", locals: { project_tag: ProjectTag.new, message: "Tag was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ProjectTag.new, partial: "account/project_tags/form", locals: { project_tag: @project_tag }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @project_tag.update(project_tag_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project_tag, partial: "account/project_tags/project_tag", locals: { project_tag: @project_tag, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@project_tag, template: "account/project_tags/edit", locals: { project_tag: @project_tag, messages: @project_tag.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @project_tag.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@project_tag) }
    end
  end

  private

  def set_project_tag
    @project_tag = ProjectTag.find(params[:id])
  end

  def project_tag_params
    params.require(:project_tag).permit(:name, :account_id)
  end
end
