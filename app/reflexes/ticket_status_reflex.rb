class TicketStatusReflex < ApplicationReflex
  def change
    ticket = Ticket.find(element.dataset["ticket-id"])
    ticket.update(ticket_status_id: element.dataset["status-id"])
    ticket.save
  end
end
