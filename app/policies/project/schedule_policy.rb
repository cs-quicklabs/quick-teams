class Project::SchedulePolicy < Project::BaseProjectPolicy
  def create?
    project = record.first
    return false if project.archived?
    user.admin?
  end
end
