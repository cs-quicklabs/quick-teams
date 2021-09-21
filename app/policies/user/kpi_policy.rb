class User::KpiPolicy < User::BaseUserPolicy
  def index?
    true
  end

  def stats?
    true
  end

  def self_record?
    employee = record.first
    return false if employee.kpi.nil?
    user.id == employee.id
  end

  def record?
    employee = record.first
    return false if employee.kpi.nil?
    return true if user.admin? and (user.id != employee.id)
    user.subordinate?(employee)
  end
end
