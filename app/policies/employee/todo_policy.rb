class Employee::TodoPolicy < ApplicationPolicy
  def update?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def destroy?
    true
  end
end
