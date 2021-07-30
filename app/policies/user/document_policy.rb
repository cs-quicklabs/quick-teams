class User::DocumentPolicy < User::BaseUserPolicy
  def create?
    user.admin?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
