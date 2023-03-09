class User::KpiPolicy < User::BaseUserPolicy
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
    is_active? and (is_admin? or is_project_manager? or is_team_lead? or is_project_observer?) and (user.id != employee.id)
  end
end
