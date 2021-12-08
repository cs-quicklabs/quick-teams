class CommentsMailer < ApplicationMailer
  def commented_email
    @actor = params[:actor]
    @employee = params[:employee]
    @report = params[:report]
    mail(to: @employee.email, subject: "New Comment on Report", template_path: "mailers/comments_mailer")
  end
end
