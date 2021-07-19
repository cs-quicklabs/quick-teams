class User::FeedbackPolicy < User::BaseUserPolicy
  def update?
    edit?
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

  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  def index?
    return true if user.admin?
    return true if user.lead? and user.subordinate?(record)
    user.id == record.id
  end

  def comment?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
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
