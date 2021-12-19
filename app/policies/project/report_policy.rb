class Project::ReportPolicy < Project::BaseProjectPolicy
  def edit?
    report = record.last
    super and not report.submitted?
  end

  def comment?
    create?
  end

  def destroy?
    user.admin?
  end
end
