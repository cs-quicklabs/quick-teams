class Survey::AssigneesController < Survey::BaseController
  before_action :set_survey, only: [:index, :create, :destroy]

  def index
    authorize [:survey, :assignee]
    if @survey.project?
      @pagy, @assignees = pagy_nil_safe(params, Project.where(kpi_id: @survey).order(:name), items: LIMIT)
      @assigns = Project.active.where(kpi_id: nil).order(:name)
    else
      @pagy, @assignees = pagy_nil_safe(params, User.all_users.where(kpi_id: @survey.id).order(:first_name), items: LIMIT)
      @assigns = User.where(kpi_id: nil).order(:first_name)
    end
    render_partial("survey/assignees/assignee", collection: @assignees, cached: true) if stale?(@assignees + @assigns + [@survey])
  end

  def create
    authorize [:survey, :assignee]
    if @survey.project?
      @assignee = Project.find(params[:assign_id])
      @assigns = Project.where(kpi_id: nil).order(:name)
    else
      @assignee = User.find(params[:assign_id])
      @assigns = User.where(kpi_id: nil).order(:first_name)
    end

    respond_to do |format|
      if @assignee.update(kpi_id: @survey.id)
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:assignees, partial: "survey/assignees/assignee", locals: { assignee: @assignee }) +
                               turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Assignee was added successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Unable to add assgnee. Plese try again later" }) }
      end
    end
  end

  def destroy
    authorize [:survey, :assignee]
    if @survey.project?
      @assignee ||= Project.find(params[:id])
      @assigns = Project.where(kpi_id: nil).order(:name)
    else
      @assignee ||= User.find(params[:id])
      @assigns = User.where(kpi_id: nil).order(:first_name)
    end
    respond_to do |format|
      if @assignee.update(kpi_id: nil)
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Assignee was deleted." }) +
                               turbo_stream.remove(@assignee)
        }
      else
        render turbo_stream: turbo_stream.replace("add-assignee", partial: "survey/assignees/form", locals: { assigns: @assigns, survey: @survey, message: "Unable to delete Assignee" })
      end
    end
  end

  private

  def set_survey
    @survey = Survey::Survey.find(params[:survey_id])
  end

  def assignee_params
    params.permit(:assign_id)
  end
end
