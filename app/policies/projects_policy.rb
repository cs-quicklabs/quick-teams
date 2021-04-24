class ProjectsPolicy < Struct.new(:user, :projects)
  def index?
    user.admin?
  end
end
