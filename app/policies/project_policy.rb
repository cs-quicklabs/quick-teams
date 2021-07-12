class ProjectPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.active.includes(:discipline, :participants, :manager, :status, :project_tags).order(:name)
      elsif user.has_managed_projects?
        user.managed_projects.active.includes(:discipline, :participants, :manager, :status, :project_tags).order(:name)
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

  def create_skill?
    user.admin?
  end
end
