class Report::RisksController < Report::BaseController
  def index
    authorize :report, :index?

    risks = Risk.includes(:project, :user).where("projects.archived = ?", false).references(:projects).order("lower(name) ASC").open
    @pagy, @risks = pagy_nil_safe(params, risks, items: LIMIT)
    render_partial("report/risks/risk", collection: @risks, cached: false) if stale?(@risks)
  end
end
