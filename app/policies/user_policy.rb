class UserPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    return true if user.admin?

    user.id == record.id
  end

  def show?
    user.admin? or record.id == user
  end
end
