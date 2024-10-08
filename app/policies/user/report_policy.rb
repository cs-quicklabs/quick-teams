class User::ReportPolicy < User::BaseUserPolicy
  def edit?
    report = record.last
    is_active? and not report.submitted? and report.user == user
  end

  def comment?
    report = record.last
    is_admin? or is_project_manager? or is_team_lead? or report.reportable == user
  end

  def show?
    index?
  end

  def destroy?
    edit? or is_admin?
  end

  private

  def subordinate?
    employee = record.first
    user.subordinate?(employee)
  end
end
