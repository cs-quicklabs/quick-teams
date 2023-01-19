class Space::MessagePolicy < ApplicationPolicy
  def index?
    (record.first.users.include?(user) || record.first.user == user)
  end

  def new?
    record.first.user == user && !record.first.archive
  end

  def create?
    record.first.user == user
  end

  def show?
    record.last.published? || record.first.user == user || record.first.users.include?(user)
  end

  def comment?
    (record.first.users.include?(user) || record.first.user == user) && !record.first.archive && record.last.published?
  end

  def edit?
    record.first.user == user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def publish?
    record.first.user == user && !record.first.archive
  end

  def edit_comment?
    !record.first.archive?
  end
end
