class Report::ProjectsController < Report::BaseController
  def index
    authorize :report

    @pagy, @projects = pagy_nil_safe(Project.query(projects_filter_params), items: LIMIT)
    render_partial("report/projects/project", collection: @projects) if stale?(@projects)
  end

  private

  def projects_filter_params
    params.permit(*ProjectFilter::KEYS)
  end
end
