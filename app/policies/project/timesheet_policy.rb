class Project::TimesheetPolicy < Project::BaseProjectPolicy
  def edit?
    timesheet = record.last
    user.admin? or timesheet.user == user or user.is_manager?(project)
  end

  def destroy?
    timesheet = record.last
    user.admin? or timesheet.user == user or user.is_manager?(project)
  end

  def update?
    edit?
  end
end
