class MessagesMailer < ApplicationMailer
  def message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @message = params[:message]
    @space = params[:space]

    mail(
      to: @employee.email,
      subject: "Quick Teams: New Thread Added to Space",
      template_path: "mailers/messages_mailer",
    )
  end

  def update_message_email
    @actor = params[:actor]
    @employee = params[:employee]
    @message = params[:message]
    @space = params[:space]

    mail(
      to: @employee.email,
      subject: "Quick Teams: Thread Updated in Space",
      template_path: "mailers/messages_mailer",
    )
  end
end
