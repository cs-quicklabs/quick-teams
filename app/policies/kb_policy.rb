class KbPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.includes(:discipline, :job, :user).order(created_at: :desc)
      else
        scope.visible_documents_for_user(user)
      end
    end

    private

    attr_reader :user, :scope
  end

  def destroy?
    edit?
  end

  def edit?
    return true if user.admin?
  end

  def update?
    edit?
  end

  def new?
    edit?
  end

  def create?
    edit?
  end

  def index?
    true
  end
end
