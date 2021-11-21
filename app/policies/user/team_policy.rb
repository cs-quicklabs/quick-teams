class User::TeamPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    return true if user.project_team?(record.first)
    false
  end
end
