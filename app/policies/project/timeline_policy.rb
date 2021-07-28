class Project::TimelinePolicy < Project::BaseProjectPolicy
  def index?
    user.admin?
  end
end
