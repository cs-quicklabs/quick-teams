class Project::ReportPolicy < Project::BaseProjectPolicy
  def edit?
    report = record.last
    report.user == user and not report.submitted?
  end

  def comment?
    create?
  end

  def destroy?    
    edit? or is_admin?
  end
end
