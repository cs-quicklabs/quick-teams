class KpisPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
