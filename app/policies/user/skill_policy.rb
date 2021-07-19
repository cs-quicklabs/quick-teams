class User::SkillPolicy < User::BaseUserPolicy
  def create?
    true
  end

  def index?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end
end
