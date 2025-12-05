class AddTicket < Patterns::Service
  def initialize(params, actor)
    @ticket = Ticket.new(params)
    @actor = actor
  end

  def call
    add_ticket
    send_email
    ticket
  rescue StandardError
    ticket
  end

  private

  attr_reader :ticket, :actor, :assignee

  def add_ticket
    ticket.save!
    @assignee = ticket.ticket_label.user
  end

  def send_email
    return unless deliver_email?

    TicketsMailer.with(ticket: ticket, assignee: assignee, actor: actor)
                 .deliver_email
                 .deliver_later
  end

  def deliver_email?
    assignee.present? &&
      actor != assignee &&
      assignee.email_enabled &&
      assignee.account.email_enabled &&
      assignee.sign_in_count.positive?
  end
end
