class FeedbacksMailer < ApplicationMailer
  def publish_email
    @feedback = params[:feedback]
    mail(to: @feedback.critiquable.email, subject: "Quick Teams: New Feedback Published", template_path: "mailers/feedbacks_mailer")
  end
end
