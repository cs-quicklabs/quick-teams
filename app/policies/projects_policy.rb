class ProjectsPolicy < Struct.new(:user, :projects)
  def index?
    user.admin? or user.project_manager? or user.project_observer?
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
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

  def show?
    user.admin? or user.is_manager?(record) or user.is_observer?(record)
  end
end
