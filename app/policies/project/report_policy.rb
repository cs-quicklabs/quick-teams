class Project::ReportPolicy < Project::BaseProjectPolicy
  def edit?
    return false if !is_active?
    report = record.last
    report.user == user and not report.submitted?
  end

  def comment?
    return false if !is_active?
    report = record.last
    is_admin? or is_project_manager?
  end

  def destroy?
    edit? and is_admin?
  end
end
