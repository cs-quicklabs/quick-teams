class AccountPolicy < Struct.new(:user, :account)
  def index?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def update?
    user.admin?
  end

  def account?
    user.is_owner?
  end

  def preferences?
    user.is_owner?
  end

  def billings?
    user.is_owner?
  end
end
