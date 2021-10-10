class Project::GoalPolicy < Project::BaseProjectPolicy
  def show?
    user.admin? or user.is_manager?(record.first)
  end

  def update?
    milestone = record.last
    project = record.first
    return false if project.archived?
    return true if user.admin?

    user.is_manager?(project) and milestone.user_id == user.id
  end

  def create?
    project = record.first
    return false if project.archived?
    return true if user.admin?
    user.admin? or user.is_manager?(project)
  end

  def comment?
    project = record.first
    milestone = record.last
    return true if user.admin?
    return true if user.is_manager?(project)
  end

  def destroy?
    milestone = record.last
    project = record.first
    return false if project.archived?
    return true if user.admin?

    user.is_manager?(project) and milestone.user_id == user.id
  end

  def edit?
    milestone = record.last
    project = record.first
    return false if project.archived?
    return true if user.admin?

    user.is_manager?(project) and milestone.user_id == user.id
  end
end
