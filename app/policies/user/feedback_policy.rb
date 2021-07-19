class User::FeedbackPolicy < User::BaseUserPolicy
  def update?
    edit?
  end

  def destroy?
    feedback = record.last
    return false if feedback.published?
    return true if user.admin?
    return feedback.user == user if (user.lead? and feedback_for_subordinate?)
    false
  end

  def edit?
    feedback = record.last
    (user.admin? or feedback_for_subordinate?) and !feedback.published?
  end

  def comment?
    employee = record.first
    return true if user.admin?
    return true if user.lead? and user.subordinate?(employee)
    false
  end

  private

  def feedback_for_subordinate?
    feedback = record.last
    user.subordinate?(feedback.critiquable)
  end

end
