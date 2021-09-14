class Project::SurveyPolicy < Project::BaseProjectPolicy
  def index?
    true
  end

  def take?
    project = record.first
    return false if project.archived?
    return true if user.admin?
    return true if user.is_manager?(project)
  end
end
