class SurveysPolicy < Struct.new(:user, :surveys)
  def index?
    user.admin?
  end

  def update?
    user.admin?
  end

  def create?
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

  def show?
    user.admin?
  end

  def clone?
    user.admin?
  end

  def assignees?
    user.admin?
  end
end
