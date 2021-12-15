class User::ReportPolicy < User::BaseUserPolicy
  def edit?
    is_active? and (is_admin? or not record.last.submitted?)
  end

  def comment?
    report = record.last
    return true if is_admin? or is_project_manager? or is_team_lead?
    return true if (report.user == user) or (report.reportable == user)
    false
  end

  def show?
    index?
  end

  private

  def report_for_subordinate?
    report = record.last
    user.subordinate?(report.user)
  end
end
