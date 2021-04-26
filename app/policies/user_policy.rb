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
    index?
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

  def show_timeline?
    user.admin?
  end

  def show_timesheets?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def show_feedbacks?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def show_goals?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def show_team?
    return true if user.admin?
    return true if user.lead? or record.lead?
    false
  end

  def show_schedules?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end
end
