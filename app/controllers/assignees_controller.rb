class AssigneesController < BaseController
  before_action :set_template, only: %i[ create destroy ]
  before_action :set_template_assignee, only: %i[destroy]

  def create
    authorize :template

    @template_assignee = TemplatesAssignee.create(assignee_params)
    respond_to do |format|
      if @template_assignee.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:assignees, partial: "templates/assignee", locals: { template_assignee: @template_assignee }) +
                               turbo_stream.replace("add-assignee", partial: "form", locals: { template_assignee: TemplatesAssignee.new(template_id: @template.id), message: "Assignee was added successfully." })
        }
      else
        turbo_stream.replace("add-assignee", partial: "form", locals: { template_assignee: TemplatesAssignee.new(template_id: @template.id), message: "Failed to add. Please try again later." })
      end
    end
  end

  def destroy
    authorize @template
    @template_assignee.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@template_assignee) }
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

  def set_template_assignee
    @template_assignee ||= TemplatesAssignee.find_by(template_id: params["template_id"], assignable_id: params["id"])
  end
end
