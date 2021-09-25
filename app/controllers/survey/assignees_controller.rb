class Survey::AssigneesController < Survey::BaseController
  before_action :set_survey, only: [:index, :create, :destroy]
  before_action :set_assignee, only: [:create]

  def index
    authorize [:survey, :assignee]

    klass = @survey.survey_for.capitalize.constantize
    @pagy, @assignees = pagy_nil_safe(params, klass.available.where(kpi_id: @survey), items: LIMIT)
    @assigns = klass.available.where(kpi_id: nil)
    render_partial("survey/assignees/assignee", collection: @assignees, cached: true) if stale?(@assignees + @assigns + [@survey])
  end

  def create
    authorize [:survey, :assignee]

    @assigns = @klass.available.where(kpi_id: nil)
    respond_to do |format|
      if @assignee.update(kpi_id: @survey.id)
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:assignees, partial: "survey/assignees/assignee", locals: { assignee: @assignee }) +
                               turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Assignee was added successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Unable to add assignee. Plese try again later" }) }
      end
    end
  end

  def destroy
    authorize [:survey, :assignee]
    klass = @survey.survey_for.capitalize.constantize
    @assignee = klass.find(params[:id])
    @assignee.update(kpi_id: nil)
    @assigns = klass.available.where(kpi_id: nil)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey }) +
                             turbo_stream.remove(@assignee)
      }
    end
  end

  private

  def set_assignee
    @klass = @survey.survey_for.capitalize.constantize
    @assignee = @klass.find(assignee_params[:assign_id])
  end

  def set_survey
    @survey ||= Survey::Survey.find(params[:survey_id])
  end

  def assignee_params
    params.permit(:assign_id)
  end
end
