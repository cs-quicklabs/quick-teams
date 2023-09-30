class CommentMailer < ApplicationMailer
  def comment_email
    @actor = params[:actor]
    @employee = params[:employee]
    @comment = params[:comment]
    @message = params[:message]
    @space = params[:space]
    mail(to: @employee.email, subject: "Quick Teams: New Comment Added", template_path: "mailers/comment_mailer")
  end
end
