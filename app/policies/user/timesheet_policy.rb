class User::TimesheetPolicy < User::BaseUserPolicy
  def create?
    is_active? and self?
  end

  def edit?
    # user shoud be active and
    # admin, project manager or creator of timesheet can edit
    timesheet = record.last
    project = timesheet.project
    (is_active? && !project.archived?) and (is_admin? or is_project_manager? or (timesheet.user == user))
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
