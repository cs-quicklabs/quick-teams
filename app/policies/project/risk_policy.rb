class Project::RiskPolicy < Project::BaseProjectPolicy
  def update?
    project = record.first
    note = record.last
    (user.admin? or note.user_id == user.id) and not project.archived?
  end

  def index?
    project = record.first
    return true if user.admin?
    user.is_manager?(project)
  end

  def create?
    project = record.first
    return false if project.archived?
    return true if user.admin?
    user.is_manager?(project)
  end

  def destroy?
    project = record.first
    note = record.last
    return false if project.archived?
    return true if user.admin?
    note.user_id == user.id
  end
end
