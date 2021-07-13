class User::FeedbackPolicy < User::BaseUserPolicy
  def update?
    edit?
  end

  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def destroy?
    return false if record.published?
    return true if user.admin?
    return record.user == user if (user.lead? and subordinate?)
    false
  end

  def edit?
    (user.admin? or subordinate?) and !record.published?
  end

  private

  def self?
    record.critiquable == user
  end

  def subordinate?
    user.subordinate?(record.critiquable)
  end

  def self_or_subordinate?
    self? or subordinate?
  end
end
