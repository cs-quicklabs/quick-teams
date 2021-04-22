class Employee::GoalPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    return true if user.admin?
    false
  end

  def index?
    true
  end

  def show?
    user.admin? or record.user == user or record.goalable_id == user.id
  end
end
