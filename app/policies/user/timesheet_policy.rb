class User::TimesheetPolicy < User::BaseUserPolicy
  def update?
    user.admin?
  end

  def create?
    true
  end

  def index?
    true
  end

  def destroy?
    timesheet = record.last
    user.admin? or timesheet.user == user
  end
end
