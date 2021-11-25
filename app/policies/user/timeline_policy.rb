class User::TimelinePolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    user.admin?
     return true if user.on_project_team?(record.first)
     return self_or_subordinate? if user.lead?
    return false unless employee.active?
    false
  end
end
