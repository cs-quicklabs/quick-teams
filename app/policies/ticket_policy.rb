class TicketPolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all.order(created_at: :desc)
      else
        label_ids = TicketLabel.where(user: @user).pluck(:id)
        Ticket.includes(:ticket_label, :ticket_status, :user).where("ticket_label_id IN (?)", label_ids).order(created_at: :desc)
      end
    end

    private

    attr_reader :user, :scope
  end

  def open?
    TicketLabel.all.pluck(:user_id).include?(@user.id) or user.admin?
  end

  def closed?
    TicketLabel.all.pluck(:user_id).include?(@user.id) or user.admin?
  end

  def create?
    true
  end

  def change_status?
    ticket = record.first
    return false if ticket.completed?
    return false if ticket.ticketstatus? and TicketStatus.all.count > 1
    return true if user.admin? or ticket.ticket_label.user_id == @user.id
  end

  def edit?
    ticket = record.first
    return false if ticket.completed?

    return true if ticket.user_id == @user.id and !ticket.ticketstatus?
  end

  def index?
    true
  end

  def show?
    true
  end

  def destroy?
    edit?
  end

  def update?
    edit?
  end

  def comment?
    ticket = record.first
    return false if ticket.completed?
    return true if @user.admin?
    return true if ticket.user_id == @user.id
    return true if ticket.ticket_label.user == @user
  end

  def new?
  end
end
