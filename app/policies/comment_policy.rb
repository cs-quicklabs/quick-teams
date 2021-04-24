class CommentPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
