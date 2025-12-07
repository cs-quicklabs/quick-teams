class TicketStatusReflex < ApplicationReflex
  def change
    ticket = Ticket.find(element.dataset["ticket-id"])
    ticket.update(ticket_status_id: element.dataset["status-id"])
    ticket.save!
    statuses = TicketStatus.all - [ticket.ticket_status]
    status_count = (statuses.pluck(:id) - [ticket.ticket_status_id]).count
    morph "#ticket-status-#{ticket.id}", render(partial: "tickets/show_buttons/assignee", locals: { ticket: ticket, status_count: status_count, statuses: statuses })
  end
end
