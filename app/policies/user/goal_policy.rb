class User::GoalPolicy < User::BaseUserPolicy
  def update?
    edit?
  end

  def create?
    employee = record.first

    return false unless employee.active?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  def edit?
    return true if user.admin?
    return user.subordinate?(record.first) if user.lead?
    false
  end

  def show?
    return true if user.admin?
    return (goal_for_subordinate? or self?) if user.lead?
    self?
  end

  def update?
    edit? && goal.progress?
  end

  def destroy?
    editable?
  end

  def edit?
    editable?
  end

  def editable?
    return true if user.admin?
    return goal_for_subordinate? if user.lead?
    false
  end

  def comment?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  private

  def goal_for_subordinate?
    goal = record.last
    user.subordinate?(goal.goalable)
  end
end
