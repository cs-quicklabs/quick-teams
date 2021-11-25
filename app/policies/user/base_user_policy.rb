class User::BaseUserPolicy < ApplicationPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
<<<<<<< HEAD
    return true if user.project_team?(record.first)
=======
    return true if user.on_project_team?(record.first)
>>>>>>> 77cf776d5408fdf48af3b36fe665d66da6e8ed59
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
