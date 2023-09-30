class WeeklyNuggetResetMailer < ApplicationMailer
  def nugget_reset_email
    @employee = params[:employee]
    mail(to: @employee.email, subject: "Quick Teams: Nuggets Reset", template_path: "mailers/weekly_nugget_reset_mailer")
  end
end
