class Report::ProjectsController < Report::BaseController
  def index
    authorize :projects

    @projects = Project.query(projects_filter_params)
    fresh_when @projects
  end

  private

  def projects_filter_params
    params.permit(*ProjectFilter::KEYS)
  end
end
