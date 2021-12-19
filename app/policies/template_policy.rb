class TemplatePolicy < ApplicationPolicy
  def create?
    user.admin? || user.lead?
  end

  def edit?
    return true if user.admin?
  end

  def index?
    user.admin? || user.lead?
  end

  def show?
    true
  end

  def destroy?
    user.admin? || user.lead?
  end

  def update?
    edit?
  end

  def new?
    user.admin? || user.lead?
  end

  def add?
    user.admin? || user.lead?
  end

  def publish?
    user.admin?
  end
end
