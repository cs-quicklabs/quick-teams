class User::BaseUserPolicy < ApplicationPolicy
  private

  def self_or_subordinate?
    employee = record.first
    (user.id == employee.id or user.subordinate?(employee))
  end

  def self?
    employee = record.first
    user.id == employee.id
  end
end
