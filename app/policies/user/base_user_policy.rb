class User::BaseUserPolicy < ApplicationPolicy
  def index?
    is_admin? or is_project_manager? or is_team_lead? or self? or is_project_observer?
  end

  def create?
    return false unless is_active?
    is_admin? or is_project_manager? or is_team_lead? or self? or is_project_observer?
  end

  def edit?
    is_active?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  private

  def is_active?
    record.first.active?
  end

  def is_project_manager?
    user.project_manager? and user.project_participant?(record.first)
  end

  def is_admin?
    user.admin?
  end

  def is_team_lead?
    user.lead? and user.subordinate?(record.first)
  end

  def self_or_subordinate?
    self? or subordinate? or is_project_observer?
  end

  def self?
    user.id == record.first.id
  end

  def subordinate?
    user.subordinate?(record.first)
  end

  def is_project_observer?
    user.project_observer? and user.observed_project_participant?(record.first)
  end
end
