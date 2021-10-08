class Project::RisksController < Project::BaseController
  before_action :set_risk, only: %i[ destroy edit update ]
  include ActionView::RecordIdentifier

  def index
    authorize [@project, :risk]

    @risk = Risk.new
    @pagy, @risks = pagy_nil_safe(params, @project.risks.includes(:user).order(:status), items: LIMIT)
    render_partial("project/risks/risk", collection: @risks) if stale?(@risks + [@project])
  end

  def destroy
    authorize [@project, @risk]

    @risk.destroy
    Event.where(eventable: @project, trackable: @risk).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@risk) }
    end
  end

  def edit
    authorize [@project, @risk]
  end

  def update
    authorize [@project, @risk]
    @risk.update(status: !@risk.status)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(@risk, partial: "project/risks/risk", locals: { risk: @risk })
      }
    end
  end

  def create
    authorize [@project, Risk]

    @risk = AddProjectRisk.call(@project, risk_params, current_user).result
    respond_to do |format|
      if @risk.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(Risk.new, partial: "project/risks/form", locals: { risk: Risk.new }) +
                               turbo_stream.prepend(:risks, partial: "project/risks/risk", locals: { risk: @risk })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Risk.new, partial: "project/risks/form", locals: { risk: @risk }) }
      end
    end
  end

  private

  def set_risk
    @risk ||= Risk.find(params["id"])
  end

  def risk_params
    params.require(:risk).permit(:body)
  end
end
