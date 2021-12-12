class Project::TimesheetPolicy < Project::BaseProjectPolicy
  def edit?
    project = record.first
    timesheet = record.last
    user.admin? or timesheet.user == user or user.is_manager?(project)
  end

  def destroy?
    edit?
  end

  def update?
    edit?
  end
end
