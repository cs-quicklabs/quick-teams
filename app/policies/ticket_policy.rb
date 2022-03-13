class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  def create?
    true
  end

  def change_status?
    return true if user.admin?
  end

  def edit?
    return true if user.admin?
  end

  def index?
    true
  end

  def show?
    true
  end

  def labels?
    true
  end

  def destroy?
    true
  end

  def update?
    edit?
  end

  def comment?
    ticket = record.first
    @user.admin? || @user.account_id == ticket.account_id
    ticket.ticket_label.user == @user
  end

  def new?
    true
  end
end
