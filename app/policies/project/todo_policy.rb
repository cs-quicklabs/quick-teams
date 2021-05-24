class Project::TodoPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def index?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
