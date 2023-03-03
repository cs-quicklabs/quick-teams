class Project::GoalPolicy < Project::BaseProjectPolicy
  def comment?
    create?
  end

  def edit?
    milestone = record.last
    project = record.first
    return false if project.archived?
    return true if user.admin?

    (user.is_observer?(project) or user.is_manager?(project)) and milestone.user_id == user.id
  end
end
