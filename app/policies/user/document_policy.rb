class User::DocumentPolicy < User::BaseUserPolicy
  def destroy?
    edit?
  end

  def edit?
    employee = record.first
    document = record.last
    return false unless employee.active?
    return true if user.admin?
    document.user == user
  end

  def update?
    edit?
  end

  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return subordinate? if user.lead?
    self?
  end
end
