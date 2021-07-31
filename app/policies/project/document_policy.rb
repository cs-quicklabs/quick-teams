class Project::DocumentPolicy < Project::BaseProjectPolicy
  def create?
    user.admin?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def destroy?
    true
  end
  def edit?
    true
  end
  def update?
    true
  end
end
