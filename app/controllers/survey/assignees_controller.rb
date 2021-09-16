class Survey::AssigneesController < Survey::BaseController
  before_action :set_survey, only: [:index, :create, :destroy]

  def index
    authorize [:survey, :assignee]
    if @survey.project?
      @pagy, @assignees = pagy_nil_safe(params, Project.where(kpi_id: @survey).order(:name), items: LIMIT)
      @assigns = Project.where(kpi_id: nil).order(:name)
    else
      @pagy, @assignees = pagy_nil_safe(params, User.all_users.where(kpi_id: @survey.id).order(:first_name), items: LIMIT)
      @assigns = User.where(kpi_id: nil).order(:first_name)
    end
    render_partial("survey/assignees/assignee", collection: @assignees, cached: true) if stale?(@assignees)
    fresh_when @assignees + @assigns + [@survey]
  end

  def create
    authorize [:survey, :assignee]
    if @survey.project?
      Project.where(id: params[:assign_id]).update(kpi_id: @survey.id)
    else
      User.where(id: params[:assign_id]).update(kpi_id: @survey.id)
    end
    redirect_to survey_assignees_path(@survey)
  end

  def destroy
    authorize [:survey, :assignee]
    if @survey.project?
      Project.where(id: params[:id]).update(kpi_id: nil)
    else
      User.where(id: params[:id]).update(kpi_id: nil)
    end
    redirect_to survey_assignees_path(@survey)
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:survey_id])
  end

  def assignee_params
    params.permit(:assign_id)
  end
end
