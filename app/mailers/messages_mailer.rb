class MessagesMailer < ApplicationMailer
  def message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @message = params[:message]
    mail(to: @employee.email, subject: "New Thread added into space", template_path: "mailers/messages_mailer")
  end
end
