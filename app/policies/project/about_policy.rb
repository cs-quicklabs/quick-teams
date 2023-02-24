class Project::AboutPolicy < Project::BaseProjectPolicy
  def index?
    is_admin? or is_project_manager? or is_project_observer?
  end

  def edit?
    index? && is_active?
  end

  def update?
    edit?
  end

  def destroy_observer?
    edit?
  end
end
