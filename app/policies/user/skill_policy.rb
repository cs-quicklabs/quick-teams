class User::SkillPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return subordinate? if user.lead?
    self?
  end
end
