class User::SchedulePolicy < User::BaseUserPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    employee = record.first

    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    user.id == employee.id
  end

  def destroy?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
