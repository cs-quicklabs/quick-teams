class UserPolicy < ApplicationPolicy
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

  def create_goal?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    false
  end

  def create_feedback?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    false
  end

  def create_comment?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    false
  end

  def profile?
    true
  end

  def password?
    true
  end

  def update_password?
    true
  end
end
