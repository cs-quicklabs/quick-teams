class SpacesPolicy < Struct.new(:user, :spaces)
  def index?
    true
  end

  def update?
    true
  end

  def create?
    true
  end

  def edit?
    true
  end

  def new?
    true
  end

  def destroy?
    true
  end

  def show?
    true
  end
end
