class User::GoalPolicy < User::BaseUserPolicy
  def create?
    is_active? or is_admin? or is_project_manager? or is_team_lead? or is_project_observer?
  end

  def show?
    is_admin? or _is_project_manager? or _is_team_lead? or self? or is_project_observer?
  end

  def edit?
    (is_admin? or _is_project_manager? or _is_team_lead? or is_project_observer?) and record.last.progress?
  end

  def comment?
    return false unless is_active? and record.last.progress?
    is_admin? or _is_project_manager? or _is_team_lead? or is_project_observer? or (self? and record.last.permission?)
  end

  private

  def _is_team_lead?
    receiver = record.last.goalable
    user.subordinate?(receiver) and user.lead?
  end

  def _is_project_manager?
    receiver = record.last.goalable
    user.project_participant?(receiver) and user.project_manager?
  end

  def goal_for_subordinate?
    goal = record.last
    user.subordinate?(goal.goalable)
  end
end
