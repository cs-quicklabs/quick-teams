class Survey::AssigneesController < Survey::BaseController
  before_action :set_survey, only: [:index, :create, :destroy]
  before_action :set_assignee, only: [:create]

  def index
    authorize [:survey, :assignee]

    klass = @survey.survey_for.resolve_class
    search = @survey.survey_type == "culture" ? klass.available.where(culture_kpi_id: @survey) : klass.available.where(kpi_id: @survey)
    @pagy, @assignees = pagy_nil_safe(params, search, items: LIMIT)
    @assigns = @survey.survey_type == "culture" ? klass.available.where(culture_kpi_id: nil) : klass.available.where(kpi_id: nil)
    render_partial("survey/assignees/assignee", collection: @assignees, cached: true) if stale?(@assignees + @assigns + [@survey])
  end

  def create
    authorize [:survey, :assignee]

    @assigns = @survey.survey_type == "culture" ? @klass.available.where(culture_kpi_id: nil) : @klass.available.where(kpi_id: nil)
    update_result = @survey.survey_type == "culture" ? @assignee.update(culture_kpi_id: @survey.id) : @assignee.update(kpi_id: @survey.id)
    respond_to do |format|
      if update_result
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

    klass = @survey.survey_for.resolve_class
    @assignee = klass.find(params[:id])
    @survey.survey_type == "culture" ? @assignee.update(culture_kpi_id: nil) : @assignee.update(kpi_id: nil)
    @assigns = @survey.survey_type == "culture" ? klass.available.where(culture_kpi_id: nil) : klass.available.where(kpi_id: nil)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey }) +
                             turbo_stream.remove(@assignee)
      }
    end
  end

  private

  def set_assignee
    @klass = @survey.survey_for.resolve_class
    @assignee = @klass.find(assignee_params[:assign_id])
  end

  def set_survey
    @survey ||= Survey::Survey.find(params[:survey_id])
  end

  def assignee_params
    params.permit(:assign_id)
  end
end
