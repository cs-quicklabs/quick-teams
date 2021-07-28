class Project::BaseProjectPolicy < ApplicationPolicy
  def index?
    project = record.first
    user.admin? or user.is_manager?(project)
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def show?
    user.admin?
  end
end
