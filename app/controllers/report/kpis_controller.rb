class Report::KpisController < Report::BaseController
  def index
    authorize :report

    kpis = filtered_kpis
    @pagy, @kpis = pagy_nil_safe(params, kpis, items: LIMIT)
    render_partial("report/kpis/kpi", collection: @kpis, cached: false)
  end

  def performance_report
    authorize :report
    @kpis = filtered_kpis
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Employee's performance",
               page_size: "A4",
               template: "report/kpis/performance_report",
               layout: "pdf",
               lowquality: true,
               formats: [:html],
               zoom: 1,
               dpi: 75
      end
    end
  end

  private

  def filtered_kpis
    Survey::Attempt.joins(:survey).includes(:actor, :survey).preload(:participant).query(attempt_filter_params, nil, created_at: :desc)
  end

  def attempt_filter_params
    params.permit(*Survey::AttemptFilter::KEYS)
  end
end
