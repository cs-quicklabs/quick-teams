class User::SchedulePolicy < User::BaseUserPolicy
  def update?
    create?
  end

  def destroy?
    create?
  end

  def edit?
    create?
  end

  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    false
  end
end
