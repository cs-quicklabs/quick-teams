class User::FeedbackPolicy < User::BaseUserPolicy
  def destroy?
    feedback = record.last
    return false unless is_active? and not feedback.published?
    return true if is_admin?
    return feedback.user == user if _is_team_lead? or _is_project_manager? or is_project_observer?
    false
  end

  def edit?
    feedback = record.last
    return false unless is_active? and not feedback.published?
    is_admin? or _is_team_lead? or _is_project_manager? or is_project_observer?
  end

  def comment?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  def create?
    is_active? and (is_admin? or is_project_manager? or is_team_lead? or is_project_observer?)
  end

  def show?
    employee = record.first
    is_admin? or _is_team_lead? or _is_project_manager? or self? or is_project_observer?
  end

  private

  def _is_team_lead?
    receiver = record.last.critiquable
    user.subordinate?(receiver) and user.lead?
  end

  def _is_project_manager?
    receiver = record.last.critiquable
    user.project_participant?(receiver) and user.project_manager?
  end
end
