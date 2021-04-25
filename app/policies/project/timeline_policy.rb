class Project::TimelinePolicy < Struct.new(:user, :timeline)
  def index?
    user.admin?
  end
end
