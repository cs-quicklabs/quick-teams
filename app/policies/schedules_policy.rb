class SchedulesPolicy < Struct.new(:user, :schedules)
  def index?
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

  def new?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def occupancy?
    user.admin?
  end

  def jobs_occupancy?
    user.admin?
  end

  def roles_occupancy?
    user.admin?
  end
end
