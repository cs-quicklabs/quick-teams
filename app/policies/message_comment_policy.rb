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
    record.message.space.archive == false and (record.message.space.user == user || record.user == user)
  end
end
