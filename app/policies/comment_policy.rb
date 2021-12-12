class CommentPolicy < ApplicationPolicy
  def create?
    return true if user.admin?
    return true if report.user == user
    return true if report.reportable == user
    false
  end
end
