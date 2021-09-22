class Report::KpisController < Report::BaseController
  def index
    authorize :report

    kpis = Survey::Attempt.joins(:survey).query(attempt_filter_params, nil, created_at: :desc)
    @pagy, @kpis = pagy_nil_safe(params, kpis, items: LIMIT)
    render_partial("report/kpis/kpi", collection: @kpis, cached: false)
  end

  private

  def attempt_filter_params
    params.permit(*Survey::AttemptFilter::KEYS)
  end
end
