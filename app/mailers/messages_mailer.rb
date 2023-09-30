class MessagesMailer < ApplicationMailer
  def message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @message = params[:message]
    @space = params[:space]
    mail(to: @employee.email, subject: "Quick Teams: New Thread added into space", template_path: "mailers/messages_mailer")
  end

  def update_message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @message = params[:message]
    @space = params[:space]
    mail(to: @employee.email, subject: "Quick Teams: Updated thread into space", template_path: "mailers/messages_mailer")
  end
end
