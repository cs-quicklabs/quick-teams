class User::TimelinePolicy < User::BaseUserPolicy
  def index?
    is_admin?
  end
end
