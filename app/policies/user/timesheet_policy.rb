class User::TimesheetPolicy < User::BaseUserPolicy
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

  def index?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    user.id == employee.id
  end
end
