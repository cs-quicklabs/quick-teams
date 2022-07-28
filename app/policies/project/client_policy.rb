class Project::ClientPolicy < Project::BaseProjectPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end
end
