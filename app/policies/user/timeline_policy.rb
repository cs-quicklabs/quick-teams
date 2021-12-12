class User::TimelinePolicy < User::BaseUserPolicy
  def index?
    user.admin?
  end
end
