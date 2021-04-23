class Employee::FeedbackPolicy < ApplicationPolicy
  def update?
    user.admin? or record.user == user
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    user.admin? or record.user == user or record.critiquable_id == user.id
  end

  def destroy?
    update?
  end
end
