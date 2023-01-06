class Space::MessagePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def show?
    true
  end

  def comment?
    true
  end
end
