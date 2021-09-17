class Project::KpiPolicy < Project::BaseProjectPolicy
  def index?
    true
  end

  def stats?
    true
  end

  def record?
    project = record.first
    return false if project.kpi.nil?
    user.admin? || user.is_manager?(project)
  end
end
