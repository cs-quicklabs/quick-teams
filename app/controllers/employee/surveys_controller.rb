class Employee::SurveysController < Employee::BaseController
  def index
    authorize [@employee, :survey]

    @surveys = @employee.surveys
    @pagy, @filled_surveys = pagy_nil_safe(params, @employee.filled_surveys.order(created_at: :desc), items: LIMIT)
    render_partial("employee/surveys/survey", collection: @filled_surveys, cached: true) if stale?(@filled_surveys + @surveys + [@employee])
  end
end
