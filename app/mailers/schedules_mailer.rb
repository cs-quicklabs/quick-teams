class SchedulesMailer < ApplicationMailer
  def updated_email
    @employee = params[:employee]
    @message = params[:message]
    mail(to: @employee.email, subject: "Quick Teams: Schedule Updated", template_path: "mailers/schedules_mailer")
  end

  def relieved_email
    @employee = params[:employee]
    @project = params[:project]
    mail(to: @employee.email, subject: "Quick Teams: Relieved From Project", template_path: "mailers/schedules_mailer")
  end
end
