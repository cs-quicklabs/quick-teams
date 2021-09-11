class Project::SurveysController < Project::BaseController
  def index
    authorize [@project, :survey]

    @surveys = @project.surveys
    @pagy, @filled_surveys = pagy_nil_safe(params, @project.filled_surveys.order(created_at: :desc), items: LIMIT)
    render_partial("project/surveys/survey", collection: @filled_surveys, cached: true) if stale?(@filled_surveys + [@project])
  end
end
