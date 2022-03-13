class CommentPolicy < ApplicationPolicy
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
