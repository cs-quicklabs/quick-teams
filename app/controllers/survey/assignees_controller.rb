class Survey::AssigneesController < Survey::BaseController
  before_action :set_survey, only: [:index, :create, :destroy]

  def index
    authorize [:survey, :assignee]

    klass = @survey.survey_for.capitalize.constantize
    @pagy, @assignees = pagy_nil_safe(params, klass.available.where(kpi_id: @survey), items: LIMIT)
    @assigns = klass.available.where(kpi_id: nil)
    render_partial("survey/assignees/assignee", collection: @assignees, cached: true) if stale?(@assignees + @assigns + [@survey])
  end

  def create
    authorize [:survey, :assignee]

    klass = @survey.survey_for.capitalize.constantize
    klass.where(id: assignee_params[:assign_id]).update(kpi_id: @survey.id)
    redirect_to survey_assignees_path(@survey)
  end

  def destroy
    authorize [:survey, :assignee]

    klass = @survey.survey_for.capitalize.constantize
    klass.where(id: params[:id]).update(kpi_id: nil)
    redirect_to survey_assignees_path(@survey)
  end

  private

  def set_survey
    @survey ||= Survey::Survey.find(params[:survey_id])
  end

  def assignee_params
    params.permit(:assign_id)
  end
end
