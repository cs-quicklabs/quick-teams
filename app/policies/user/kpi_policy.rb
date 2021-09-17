class User::KpiPolicy < User::BaseUserPolicy
  def index?
    true
  end

  def stats?
    true
  end

  def record?
    employee = record.first
    return false if employee.kpi.nil?
    user.admin? || user.subordinate?(employee)
  end
end
