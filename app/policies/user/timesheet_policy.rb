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
    user.admin? or record.user == user
  end
end
