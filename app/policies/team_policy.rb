class TeamPolicy < Struct.new(:user, :team)
  def index?
    user.admin?
  end
end
