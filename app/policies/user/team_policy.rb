class User::TeamPolicy < User::BaseUserPolicy
  def index?
    employee = record.first
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    return true if employee == user
    return true if is_project_observer?
    false
  end
end
