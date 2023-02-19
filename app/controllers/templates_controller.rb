class TemplatesController < BaseController
  before_action :set_template, only: %i[ update destroy edit show ]

  def index
    authorize :template
    @template = Template.new
    templates = Template.all.order(created_at: :desc)
    @pagy, @templates = pagy_nil_safe(params, templates, items: 20)
    render_partial("templates/template", collection: @templates, cached: true) if stale?(@templates)
  end

  def new
    authorize :template
    @template = Template.new
  end

  def show
    authorize @template
    @template_assignees = @template.templates_assignees.order(created_at: :desc)
    @template_assignee = TemplatesAssignee.new
    @template_assignee.template_id = @template.id
  end

  def update
    authorize [@template]
    respond_to do |format|
      if @template.update(template_params)
        format.turbo_stream { redirect_to template_path(@template), notice: "Template was updated successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@template, partial: "templates/form", locals: { template: @template, title: "Edit Template" }) }
      end
    end
  end

  def create
    authorize :template
    @template = Template.create(template_params)
    respond_to do |format|
      if @template.errors.empty?
        format.turbo_stream { redirect_to template_path(@template), notice: "Template was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Template.new, partial: "templates/form", locals: { template: @template, title: "Add New Template" }) }
      end
    end
  end

  def edit
    authorize [@template]
  end

  def destroy
    authorize @template
    @template.destroy
    respond_to do |format|
      format.turbo_stream { redirect_to templates_path, status: 303, notice: "Template was removed successfully." }
    end
  end

  private

  def set_template
    @template ||= Template.find(params["id"])
  end

  def template_params
    params.require(:template).permit(:user_id, :title, :body)
  end
end
