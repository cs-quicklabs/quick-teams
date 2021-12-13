class User::ReportPolicy < User::BaseUserPolicy
  def update?
    edit?
  end

  def index?
    show?
  end

  def create?
    show?
  end

  def destroy?
    report = record.last
    return true if user.admin? or !report.submitted?
    false
  end

  def edit?
    report = record.last
    return true if user.admin? or !report.submitted?
  end

  def comment?
    employee = record.first
    report = record.second
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    return true if report.user == user
    return true if report.reportable == user
    false
  end

  def show?
    employee = record.first

    return false unless employee.active?
    return true if user.admin?
    return true if user.member_in_managed_project?(employee)
    return true if user.lead? and user.subordinate?(employee)
    self?
  end

  private

  def report_for_subordinate?
    report = record.last
    user.subordinate?(report.user)
  end
end
