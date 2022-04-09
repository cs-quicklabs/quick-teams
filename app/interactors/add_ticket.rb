class AddTicket < Patterns::Service
  def initialize(params, actor)
    @ticket = Ticket.new params
    @actor = actor
    @params = params
    @label = ticket.ticket_label
  end

  def call
    begin
      add_ticket
      send_email
    rescue
      ticket
    end
    ticket
  end

  private

  def add_ticket
    ticket.save!
    @assignee = TicketLabel.find(@label.id).user
  end

  def send_email
    TicketsMailer.with(ticket: ticket, assignee: @assignee, actor: actor).deliver_email.deliver_later if deliver_email?
  end

  def deliver_email?
    actor != @assignee and ticket.ticket_label.user.email_enabled and
    ticket.ticket_label.user.account.email_enabled and ticket.ticket_label.user.sign_in_count > 0
  end

  attr_reader :ticket, :actor, :params
end
