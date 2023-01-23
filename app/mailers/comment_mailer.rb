class CommentMailer < ApplicationMailer
  def comment_email
    @actor = params[:actor]
    @employee = params[:employee]
    @comment = params[:comment]
    @message = @comment.message
    @space = @message.space
    mail(to: @employee.email, subject: "New Comment Added", template_path: "mailers/spaces_mailer")
  end
end
