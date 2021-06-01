class SchedulesMailer < ApplicationMailer
  def updated_email
    @employee = params[:employee]
    @message = params[:message]
    mail(to: @employee.email, subject: "Schedule Updated", template_path: "mailers/schedules_mailer")
  end
end
