class Project::ReportPolicy < Project::BaseProjectPolicy
  def edit?
    report = record.last
    report.user == user and not report.submitted?
  end

  def comment?
    report = record.last
    is_admin? or is_project_manager?
  end

  def destroy?
    edit? or is_admin?
  end
end
