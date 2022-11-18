class Report::NuggetsController < Report::BaseController
  def index
    authorize :report
    nuggets = Nugget.includes(:skill).query(nuggets_filter_params, nil, created_at: :desc)
    @pagy, @nuggets = pagy_nil_safe(params, nuggets, items: LIMIT)
    render_partial("report/employees/employee", collection: @nuggets, cached: false)
  end

  private

  def nuggets_filter_params
    params.permit(*NuggetFilter::KEYS)
  end
end
