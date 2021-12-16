class Project::KpiPolicy < Project::BaseProjectPolicy
  def stats?
    index?
  end

  def record?
    project = record.first
    return false if project.kpi.nil?
    (is_admin? or is_project_manager?) and is_active?
  end
end
