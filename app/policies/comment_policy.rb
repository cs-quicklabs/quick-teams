class CommentPolicy < ApplicationPolicy
  def create?
    return true if user.admin?
    return subordinate? if user.lead?
    false
  end

  private

  def subordinate?
    user.subordinate?(commentable.user)
  end
end
