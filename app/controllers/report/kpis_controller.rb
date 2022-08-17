class Report::KpisController < Report::BaseController
  def index
    authorize :report

    kpis = Survey::Attempt.joins(:survey).includes(:actor, :survey).query(attempt_filter_params, nil, created_at: :desc)
    @pagy, @kpis = pagy_nil_safe(params, kpis, items: LIMIT)
    render_partial("report/kpis/kpi", collection: @kpis, cached: false)
  end

  def employees_performance_pdf
    authorize :report
    @kpis = Survey::Attempt.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Employee's performance",
               page_size: "A4",
               template: "report/kpis/employees_performance_pdf",
               layout: "pdf",
               lowquality: true,
               formats: [:html],
               zoom: 1,
               dpi: 75
      end
    end
  end

  private

  def attempt_filter_params
    params.permit(*Survey::AttemptFilter::KEYS)
  end
end
