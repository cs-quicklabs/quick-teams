class UserPolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def create?
    user.admin? && record.active
  end

  def index?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def show?
    index?
  end

  def profile?
    true
  end

  def password?
    true
  end

  def preferences?
    true
  end

  def update_password?
    true
  end
end
