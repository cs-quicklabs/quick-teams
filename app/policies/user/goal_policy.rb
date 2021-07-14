class User::GoalPolicy < User::BaseUserPolicy
  def update?
    edit?
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
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
end
