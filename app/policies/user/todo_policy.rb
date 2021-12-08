class User::TodoPolicy < User::BaseUserPolicy
  def create?
    employee = record.first
    return false unless employee.active?
    return true if user.admin?
    return self_or_subordinate? if user.lead?
    self?
  end

  def edit?
    todo = record.last
    create? && !todo.completed?
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

  def todo_completed?
    todo = record.last
    todo.completed?
  end
end
