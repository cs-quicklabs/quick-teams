class Project::AboutPolicy < Project::BaseProjectPolicy
  def index?
    is_admin? or is_project_manager?
  end

  def edit?
    index?
  end

  def update?
    index?
  end
end
