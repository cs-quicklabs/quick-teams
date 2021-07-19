class User::TeamPolicy < User::BaseUserPolicy
  def show?
    employee = record.first
    return true if user.admin?
    return (user.id == employee.id or user.subordinate?(employee)) if user.lead?
    false
  end
end
