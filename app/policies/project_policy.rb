class ProjectPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.active.includes(:discipline, :participants, :manager, :status, :project_tags)
      elsif user.project_manager? || user.project_observer?
        observed_project_ids = Project.active.joins(:project_observers).where("project_observers.user_id = ?", user).pluck(:id)
        managed_projects_ids = user.managed_projects.active.pluck(:id)
        projects = Project.active.where(id: observed_project_ids + managed_projects_ids).includes(:discipline, :participants, :manager, :status, :project_tags)
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
