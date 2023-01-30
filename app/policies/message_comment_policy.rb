class MessageCommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def destroy?
    record.user == user
  end
end
