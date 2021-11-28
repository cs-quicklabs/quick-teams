class Project::ReportPolicy < Project::BaseProjectPolicy
  def update?
    edit?
  end

  def show?
    create?
  end

  def index?
  create?
  end

  def edit?
    project = record.first
    report = record.last
    return false if project.archived?
     return true if user.admin? or !report.submitted?
  end

  def destroy?
    project = record.first
    report = record.last
    return false if project.archived?
    return true if user.admin? or !report.submitted?
  end

  def create?
    project = record.first
    return false if project.archived?
   return true if user.admin? or user.is_manager?(project)
  end

  def show_add_report_form?
    project = record.first
    !project.archived
  end
end
