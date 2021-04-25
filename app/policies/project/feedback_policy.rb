class Project::FeedbackPolicy < ApplicationPolicy
  def update?
    user.admin? or record.user == user
  end

  def create?
    user.admin?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
