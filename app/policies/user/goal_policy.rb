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

  def index?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def edit?
    return true if user.admin?
    return user.subordinate?(record.first) if user.lead?
    false
  end

  def update?
    edit? && goal.progress?
  end

  def comment?
    editable?
  end

  def destroy?
    editable?
  end

  def edit?
    editable?
  end

  private

  def self?
    goal = record.last
    goal.goalable == user
  end

  def subordinate?
    goal = record.last
    user.subordinate?(goal.goalable)
  end

  def self_or_subordinate?
    self? or subordinate?
  end

  def editable?
    return true if user.admin?
    return subordinate? if user.lead?
    false
  end

  def comment?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end
end
