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

  def index?
<<<<<<< HEAD
    return true if user.project_team?(record.first)
=======
    return true if user.on_project_team?(record.first)
>>>>>>> 77cf776d5408fdf48af3b36fe665d66da6e8ed59
    false
  end
end
