class Project::ReportPolicy < Project::BaseProjectPolicy
  def update?
    project = record.first
    user.admin? and not project.archived?
  end

  def show?
    project = record.first
    user.admin? or user.is_manager?(project)
  end

  def edit?
    project = record.first
    report = record.last
    return false if project.archived?
     !report.submitted?
  end

  def destroy?
    project = record.first
    report = record.last
    return false if project.archived?
    return true if user.admin?
    user.is_manager?(project) and report.user == user
  end

  def create?
    project = record.first
    return false if project.archived?
    user.admin?
  end

  def show_add_report_form?
    project = record.first
    !project.archived
  end
end
