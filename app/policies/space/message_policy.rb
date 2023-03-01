class Space::MessagePolicy < Space::BaseSpacePolicy
  def index?
    space = record.first
    space.users.include?(user) || space.user == user
  end

  def new?
    space = record.first
    !space.archive and space.users.include?(user)
  end

  def create?
    new?
  end

  def show?
    (record.last.published? && (record.first.users.include?(user))) || !record.last.published? && record.last.user == user
  end

  def comment?
    show? && !record.first.archive
  end

  def edit?
    record.first.users.include?(user) && !record.first.archive
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

  def destroy_comment?
    !record.first.archive? and record.first.user == user
  end
end
