class WeeklyActivityMailer < ApplicationMailer
  def weekly_summary_email
    @employee = params[:employee]
    @stats = params[:stats]
    mail(to: @employee.email, subject: "Weekly Summary", template_path: "mailers/weekly_activity_mailer")
  end
end
