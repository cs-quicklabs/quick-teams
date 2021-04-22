class Employee::SchedulePolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end
end
