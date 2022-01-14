class CommentPolicy < ApplicationPolicy
  def create?
    commentable = record.first
    return true if user.admin?
    return true if commentable.user == user
    if commentable.class == "Goal"
      return true if commentable.goalable == user
    else
      return true if commentable.reportable == user
    end
    false
  end

  def edit?
    return true if record.user == user
  end

  def update?
    return true if record.user == user
  end

  def destroy?
    return true if record.user == user
  end
end
