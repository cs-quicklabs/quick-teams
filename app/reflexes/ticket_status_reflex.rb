class TicketStatusReflex < ApplicationReflex
  def change
    ticket.update!(ticket_status_id: status_id)
    morph_ticket_status
  end

  private

  def ticket
    @ticket ||= Ticket.find(element.dataset["ticket-id"])
  end

  def status_id
    element.dataset["status-id"]
  end

  def morph_ticket_status
    statuses = TicketStatus.where.not(id: ticket.ticket_status_id)
    morph "#ticket-status-#{ticket.id}",
          render(partial: "tickets/show_buttons/assignee",
                 locals: { ticket: ticket, status_count: statuses.count, statuses: statuses })
  end
end
