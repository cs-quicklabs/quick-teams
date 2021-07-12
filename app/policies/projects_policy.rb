class ProjectsPolicy < Struct.new(:user, :projects)
  def index?
    user.admin? or user.has_managed_projects?
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show_project?(project)
    user.admin? or user.managed_projects.include?(project)
  end

  def edit?
    user.admin?
  end

  def new?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def show_skills?
    user.admin?
  end
end
