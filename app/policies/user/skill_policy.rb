class User::SkillPolicy < User::BaseUserPolicy
  def index?
    true
  end
end
