class User::ReportPolicy < User::BaseUserPolicy
  def edit?
    report = record.last
    is_active? and not report.submitted? and report.user == user
  end

  def comment?
    report = record.last
    is_admin?
    return subordinate? if user.lead?
    return report.reportable == user
  end

  def show?
    index?
  end

  def destroy?
    edit? or is_admin?
  end
end
