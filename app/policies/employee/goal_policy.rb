class Employee::GoalPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    user.admin? or record.user == user or record.goalable_id == user.id
  end

  def comment?
    user.admin? or record.user == user
  end

  def destroy?
    user.admin?
  end
end
