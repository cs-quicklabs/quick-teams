class TicketsMailer < ApplicationMailer
    def deliver_email
      @ticket = params[:ticket]
      @assignee = @ticket.ticket_label.user
      @actor = @ticket.user
      mail(to: @assignee.email, subject: "New Ticket Assigned", template_path: "mailers/tickets_mailer")
    end
  end
  