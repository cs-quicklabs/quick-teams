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
        Nugget.includes(:skill).where(user_id: @user).order(published: :asc).order(created_at: :desc)
      end
    end
  end

  def create?
    user.admin? || user.lead?
  end

  def edit?
    user.admin? || user.lead?
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
    user.admin? || user.lead?
  end

  def new?
    user.admin? || user.lead?
  end

  def publish?
    user.admin?
  end
end
