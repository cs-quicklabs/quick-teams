class Project::ReportPolicy < Project::BaseProjectPolicy
  def edit?
    report = record.last
    report.user == user and not report.submitted? and is_active?
  end

  def comment?
    report = record.last
    is_admin? or is_project_manager? and is_active?
  end

  def destroy?
    edit? and is_admin?
  end
end
