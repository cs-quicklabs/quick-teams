class Project::TimesheetPolicy < Project::BaseProjectPolicy
  def edit?
    timesheet = record.last
    project = record.first
    (is_admin? or is_project_manager? or is_project_observer? or timesheet.user == user) && is_active?
  end
end
