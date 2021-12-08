class User::TimelinePolicy < User::BaseUserPolicy
  def index?
    user.admin?
    return true if user.on_project_team?(record.first)
  end
end
