class PlannerPolicy < ApplicationPolicy
  def index?
    true 
  end

  def daily?
    true 
  end

  def weekly?
    true
  end
end
