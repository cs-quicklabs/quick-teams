class ProjectPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def show?
    user.admin? or record.id == user
  end
end
