class Report::RisksController < Report::BaseController
  def index
    authorize :report, :index?

    risks = Risk.open.where(project_id: Project.active.pluck(:id)).includes(:user)
    @pagy, @risks = pagy_nil_safe(params, risks, items: LIMIT)
    render_partial("report/risks/risk", collection: @risks, cached: false) if stale?(@risks)
  end
end
