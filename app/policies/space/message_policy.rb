class Space::MessagePolicy < Space::BaseSpacePolicy
  def index?
    space = record.first
    space.users.include?(user)
  end

  def new?
    space = record.first
    !space.archive and space.users.include?(user)
  end

  def create?
    new?
  end

  def show?
    (record.last.published? && record.first.users.include?(user)) || record.last.user == user
  end

  def comment?
    (record.first.users.include?(user)) && !record.first.archive && record.last.published?
  end

  def edit?
    record.first.users.include?(user)
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def publish?
    record.first.users.include?(user) && !record.first.archive && !record.last.published?
  end

  def delete_draft?
    record.last.user == user && !record.last.published?
  end

  def draft?
    record.first.users.include?(user) && !record.last.published?
  end

  def edit_comment?
    !record.first.archive?
  end
end
