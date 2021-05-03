class GoalPolicy < ApplicationPolicy
  def comment?
    return true if user.admin?
    return subordinate? if user.lead?
    false
  end

  private

  def subordinate?
    user.subordinate?(record.goalable)
  end
end
