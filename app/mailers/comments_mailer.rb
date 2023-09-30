class CommentsMailer < ApplicationMailer
  def commented_email
    @actor = params[:actor]
    @employee = params[:employee]
    @report = params[:report]
    mail(to: @employee.email, subject: "Quick Teams: New Comment on Report", template_path: "mailers/comments_mailer")
  end

  def commented_ticket
    @actor = params[:actor]
    @employee = params[:employee]
    @ticket = params[:ticket]
    mail(to: @employee.email, subject: "Quick Teams: New Comment on ticket", template_path: "mailers/comments_mailer")
  end
end
