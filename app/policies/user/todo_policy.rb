class User::TodoPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def edit?
    employee = record.first
    todo = record.last
    return false if todo.completed?
    return true if user.admin?
    todo.user == user
  end

  def update?
    edit?
  end

  def index?
    create?
  end

  def show?
    create?
  end

  def destroy?
    edit?
  end
end
