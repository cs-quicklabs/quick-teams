class User::TimesheetPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    self?
  end

  def update?
    edit?
  end

  def create?
    true
  end
  def edit?
     timesheet = record.last
    user.admin? or timesheet.user == user or user.is_manager
  end

  def destroy?
    timesheet = record.last
    user.admin? or timesheet.user == user or user.is_manager
  end

  def show_add_timesheet_form?
    employee = record.first
    employee.active && (employee.id == user.id) && employee.projects.size > 0
  end

  def show_timesheet_stats?
    !show_add_timesheet_form?
  end

  def show_timesheet_stats_menu?
    employee = record.first
    show_timesheet_stats? && employee.active
  end

  def show_add_goal_form?
    employee = record.first
    employee.active
  end
end
