class ProjectPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.active.includes(:discipline, :participants, :manager, :status, :project_tags)
      elsif user.project_manager?
        user.managed_projects.active.includes(:discipline, :participants, :manager, :status, :project_tags)
      end
    end

    private

    attr_reader :user, :scope
  end

  def update?
    user.admin?
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
end
