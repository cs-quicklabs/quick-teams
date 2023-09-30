class TicketsMailer < ApplicationMailer
  def deliver_email
    @ticket = params[:ticket]
    @assignee = params[:assignee]
    @actor = params[:actor]
    mail(to: @assignee.email, subject: "Quick Teams: New Ticket Assigned", template_path: "mailers/tickets_mailer")
  end
end
