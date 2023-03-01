class MessageCommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def edit?
    record.user == user and record.message.space.archive == false
  end

  def update?
    edit?
  end

  def destroy?
    space = record.message.space
    space.archive == false and (space.user == user || record.user == user)
  end
end
