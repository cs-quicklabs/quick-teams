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
    record.user == user || record.message.space.user == user
  end
end
