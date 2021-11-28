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
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  def show?
    return true if user.admin?
    self?
  end

  private

  def report_for_subordinate?
    report = record.last
    user.subordinate?(report.user)
  end
end
