class Space::MessagePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    (record.first.user == user || user.admin?) && !record.first.archive
  end

  def create?
    record.first.user == user || user.admin?
  end

  def show?
    record.last.published? || record.first.user == user || user.admin?
  end

  def comment?
    (record.first.users.include?(user) || user.admin?) && !record.first.archive && record.last.published?
  end

  def edit?
    (record.first.user == user || user.admin?)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def publish?
    (record.first.user == user || user.admin?) && !record.first.archive
  end

  def edit_comment?
    (record.first.user == user || user.admin?) && !record.first.archive?
  end
end
