class SchedulesMailer < ApplicationMailer
  TEMPLATE_PATH = "mailers/schedules_mailer"

  def updated_email
    @employee = params[:employee]
    @message = params[:message]

    mail_to_employee("Quick Teams: Schedule Updated")
  end

  def relieved_email
    @employee = params[:employee]
    @project = params[:project]

    mail_to_employee("Quick Teams: Relieved From Project")
  end

  private

  def mail_to_employee(subject)
    mail(
      to: @employee.email,
      subject: subject,
      template_path: TEMPLATE_PATH,
    )
  end
end
