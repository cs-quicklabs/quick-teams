class NuggetPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if @user.admin?
        @scope.includes(:skill).order(published: :asc).order(created_at: :desc)
      elsif @user.lead?
        @scope.includes(:skill).where(user_id: @user).order(published: :asc).order(created_at: :desc)
      end
    end
  end

  def create?
    user.admin? || user.lead?
  end

  def edit?
    nugget = record.first
    return true if user.admin?
    return false if nugget.published?
    return nugget.user == user if user.lead?
    false
  end

  def index?
    user.admin? || user.lead?
  end

  def show?
    true
  end

  def destroy?
    user.admin? || user.lead?
  end

  def update?
    edit?
  end

  def new?
    user.admin? || user.lead?
  end

  def publish?
    user.admin?
  end
end
