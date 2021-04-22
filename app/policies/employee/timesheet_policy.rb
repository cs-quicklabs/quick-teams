class Employee::TimesheetPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def destroy?
    user.admin? or record.user = user
  end
end
