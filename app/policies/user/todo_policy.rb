class User::TodoPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def update?
    true
  end

  def destroy?
    employee = record.first
    todo = record.last
    return false unless employee.active?
    return true if user.admin?
    return true if todo.user_id == user.id
    false
  end
end
