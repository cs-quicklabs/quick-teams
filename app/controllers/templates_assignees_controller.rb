class TemplatesAssigneesController < BaseController
  before_action :set_template, only: %i[ create ]
  before_action :set_resource, only: %i[ create ]
  before_action :set_template_assignee, only: %i[destroy]

  def create
    authorize :template

    @assign = TemplatesAssignee.create(assignee_params)
    @assigns = @resource.templates_assignees.includes(:template)
    respond_to do |format|
      if @assign.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:assignees, partial: "shared/templates/template", locals: { assign: @assign }) +
                               turbo_stream.replace("add-assignee", partial: "shared/templates/templateform", locals: { templates: Template.all, resource: @resource, assign: TemplatesAssignee.new, message: "Assignee was added successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("add-assignee", partial: "shared/templates/templateform", locals: { templates: @templates, resource: @resource, message: "Unable to add assignee. Plese try again later" }) }
      end
    end
  end

  def destroy
    authorize @template
    @assignee.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@assignee) }
    end
  end

  private

  def assignee_params
    params.permit(:template_id, :assignable_id, :assignable_type)
  end

  private

  def set_template
    @template ||= Template.find(params["template_id"])
  end

  def set_resource
    @resource ||= params[:assignable_type].constantize.find(params[:assignable_id])
  end

  def set_template_assignee
    @assignee = TemplatesAssignee.find(params["id"])
    @template ||= Template.find(@assignee.template_id)
  end
end
