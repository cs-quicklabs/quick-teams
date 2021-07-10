class Project::SkillPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
