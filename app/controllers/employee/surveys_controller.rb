class Employee::SurveysController < Employee::BaseController
  def index
    authorize [@employee, :survey]

    @surveys = @employee.surveys
    @pagy, @filled_surveys = pagy_nil_safe(params, @employee.filled_surveys, items: LIMIT)
    render_partial("employee/surveys/survey", collection: @surveys, cached: true)
  end
end
