class Employee::FeedbackPolicy < ApplicationPolicy
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
    update?
  end

  def edit?
    user.admin? and !record.published?
  end

  private

  def self?
    record.critiquable == user
  end

  def subordinate?
    user.subordinate?(record.critiquable)
  end

  def self_or_subordinate?
    self? or subordinate?
  end
end
