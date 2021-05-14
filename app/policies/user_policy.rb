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

  def create_goal?
    return false unless record.active?

    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    false
  end

  def create_schedule?
    return false unless record.active?
    return true if user.admin?
    false
  end

  def show_goals?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def edit_goals?
    return true if user.admin?
    return user.subordinate?(record) if user.lead?
    false
  end

  def edit_goal?(goal)
    edit_goals? && goal.progress?
  end

  def create_feedback?
    return false unless record.active?
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

  def show_team?
    return true if user.admin?
    return (user.id == record.id or user.subordinate?(record)) if user.lead?
    false
  end 

  def show_todo?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def create_todo?
    return false unless record.active?

    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    false
  end

  def show_schedules?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  private

  def self_or_subordinate?
    (user.id == record.id or user.subordinate?(record))
  end

  def self?
    user.id == record.id
  end
end
