class User::TimesheetPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    self?
  end

  def update?
    user.admin?
  end

  def create?
    true
  end

  def destroy?
    timesheet = record.last
    user.admin? or timesheet.user == user
  end
end
