class Employee::GoalPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end
end
