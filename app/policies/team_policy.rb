class TeamPolicy < Struct.new(:user, :team)
  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def update?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin?
  end

  def edit?
    user.admin?
  end
end
