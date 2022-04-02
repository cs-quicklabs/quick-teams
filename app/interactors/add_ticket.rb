class AddTicket < Patterns::Service
  def initialize(params, actor)
    @ticket = Ticket.new params
    @actor = actor
    @params = params
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
  end

  def send_email
    TicketsMailer.with(ticket: ticket).deliver_email.deliver_later if deliver_email?
  end

  def deliver_email?
    actor != ticket.ticket_label and ticket.ticket_label.user.email_enabled and
    ticket.ticket_label.user.account.email_enabled and ticket.ticket_label.user.sign_in_count > 0
  end

  attr_reader :project, :ticket, :actor, :params
end
