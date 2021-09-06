class Project::DocumentPolicy < Project::BaseProjectPolicy
  def destroy?
    edit?
  end

  def edit?
    project = record.first
    document = record.last
    return false if project.archived?
    return true if user.admin?
    document.user == user
  end

  def update?
    edit?
  end

  def create?
    project = record.first
    return false if project.archived?
    return true if user.admin?
    user.admin? or user.is_manager?(project)
  end
end
