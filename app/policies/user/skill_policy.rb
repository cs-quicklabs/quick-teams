class User::SkillPolicy < User::BaseUserPolicy
  def create?
    return false unless record.first.active?
    true
  end
end
