class ReportsController < BaseController
  def index
    authorize :reports

    @people_statuses = PeopleStatus.all
    @project_statuses = ProjectStatus.all
  end
end
