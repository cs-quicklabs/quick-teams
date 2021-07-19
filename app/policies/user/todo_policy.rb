class User::TodoPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return subordinate? if user.lead?
    self?
  end

  def update?
    true
  end

  def destroy?
    true
  end
end
