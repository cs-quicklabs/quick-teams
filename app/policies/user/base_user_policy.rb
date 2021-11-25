class User::BaseUserPolicy < ApplicationPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    return true if user.on_project_team?(record.first)
    user.id == employee.id
  end

  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return subordinate? if user.lead?
    false
  end

  private

  def self_or_subordinate?
    self? or subordinate?
  end

  def self?
    employee = record.first
    user.id == employee.id
  end

  def subordinate?
    employee = record.first
    user.subordinate?(employee)
  end
end
