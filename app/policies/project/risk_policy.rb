class Project::RiskPolicy < Project::BaseProjectPolicy
  def update?
    true
  end

  def index?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def edit?
    true
  end
end
