class Employee::TodoPolicy < ApplicationPolicy
  def update?
    edit?
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def destroy?
    editable?
  end

  def edit?
    editable?
  end

  private

  def self?
    record.todoable == user
  end

  def subordinate?
    user.subordinate?(record.todoable)
  end

  def self_or_subordinate?
    self? or subordinate?
  end

  def editable?
    return true if user.admin?
    return subordinate? if user.lead?
    false
  end
end
