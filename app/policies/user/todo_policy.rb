class User::TodoPolicy < User::BaseUserPolicy
  def update?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def destroy?
    true
  end

  def show?
    true
  end
end
