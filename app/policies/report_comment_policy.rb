class ReportCommentPolicy < ApplicationPolicy
  def comment?
    report = record.second
    return true if user.admin?
    return subordinate? if user.lead?
    return report.user == user
    return report.reportable == user
    self?
  end

  private

  def subordinate?
    employee = record.first
    user.subordinate?(employee)
  end
end
