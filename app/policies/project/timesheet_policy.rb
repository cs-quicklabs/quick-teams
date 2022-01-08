class Project::TimesheetPolicy < Project::BaseProjectPolicy
  def edit?
    timesheet = record.last
    is_admin? or is_project_manager? or timesheet.user == user
  end
end
