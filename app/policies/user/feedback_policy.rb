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
    feedback = record.last
    return false if feedback.published?
    return true if user.admin?
    return feedback.user == user if (user.lead? and subordinate?)
    false
  end

  def edit?
    feedback = record.last
    (user.admin? or subordinate?) and !feedback.published?
  end

  private

  def self?
    feedback = record.last
    feedback.critiquable == user
  end

  def subordinate?
    feedback = record.last
    user.subordinate?(feedback.critiquable)
  end

  def self_or_subordinate?
    self? or subordinate?
  end
end
