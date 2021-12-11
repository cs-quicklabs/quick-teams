class User::TimelinePolicy < User::BaseUserPolicy
  def index?
    user.admin?
    return true if user.member_in_managed_project?(record.first)
  end
end
