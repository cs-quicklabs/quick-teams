class Project::BaseProjectPolicy < ApplicationPolicy
  def index?
    is_admin? or is_project_manager?
  end

  def create?
    is_active? and index?
  end

  def edit?
    is_active? and index?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def show?
    index?
  end

  private

  def is_admin?
    user.admin?
  end

  def is_active?
    !record.first.archived?
  end

  def is_project_manager?
    user.is_manager?(record.first)
  end
end
