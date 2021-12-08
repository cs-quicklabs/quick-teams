class Report::ReportsController < Report::BaseController
  def index
    authorize :report
    reports = Report.query(reports_filter_params, nil, created_at: :desc)

    @pagy, @reports = pagy_nil_safe(params, reports, items: LIMIT)
    render_partial("report/reprots/report", collection: @reports, cached: false)
  end

  private

  def reports_filter_params
    params.permit(*ReportFilter::KEYS)
  end
end
