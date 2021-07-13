class Project::SchedulePolicy < Project::BaseProjectPolicy
  def create?
    project = record.first
    user.admin? and not project.archived?
  end
end
