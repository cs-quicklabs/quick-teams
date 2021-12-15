class User::SkillPolicy < User::BaseUserPolicy
  def show_skills?
    true
  end
end
