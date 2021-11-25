class User::KpiPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    return true if user.on_project_team?(record.first)
    self?
  end

  def stats?
    index?
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
