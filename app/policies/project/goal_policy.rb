class Project::GoalPolicy < Project::BaseProjectPolicy
  def show?
    user.admin? or user.is_manager?(record.first)
  end

  def update?
    milestone = record.last
    project = record.first
    user.admin? or (user.is_manager?(project) and milestone.user_id == user.id)
  end

  def create?
    project = record.first
    user.admin? or user.is_manager?(project)
  end

  def destroy?
    milestone = record.last
    project = record.first
    user.admin? or (user.is_manager?(project) and milestone.user_id == user.id)
  end

  def edit?
    milestone = record.last
    project = record.first
    user.admin? or (user.is_manager?(project) and milestone.user_id == user.id)
  end
end
