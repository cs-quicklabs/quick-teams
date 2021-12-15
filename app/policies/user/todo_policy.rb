class User::TodoPolicy < User::BaseUserPolicy
  def edit?
    todo = record.last
    # user should be active and todo should be incomplete
    return false unless is_active? or not todo.completed?
    # user should be admin or creator of todo
    is_admin? or todo.user.id == user.id
  end

  def show?
    is_admin? or is_project_manager? or is_team_lead? or self?
  end
end
