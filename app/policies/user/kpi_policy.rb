class User::KpiPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
<<<<<<< HEAD
    return true if user.project_team?(record.first)
=======
    return true if user.on_project_team?(record.first)
>>>>>>> 77cf776d5408fdf48af3b36fe665d66da6e8ed59
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
