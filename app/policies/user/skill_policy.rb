class User::SkillPolicy < User::BaseUserPolicy
  def show_skills?
    true
  end

  def add_skill?
    true
  end
end
