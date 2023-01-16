class MessagesMailer < ApplicationMailer
  def message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @space = params[:space]
    mail(to: @employee.email, subject: "New Thread Created into space", template_path: "mailers/messages_mailer")
  end
end
