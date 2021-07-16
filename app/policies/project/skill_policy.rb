class Project::SkillPolicy < Project::BaseProjectPolicy
  def index?
    project = record.first
    user.admin? or user.is_manager?(project)
  end

  def create?
    project = record.first
    (user.admin? or user.is_manager?(project)) and not project.archived?
  end
end
