class TodosMailer < ApplicationMailer
  TEMPLATE_PATH = "mailers/todos_mailer"

  def added_email
    set_common_params
    mail_to_employee("Quick Teams: New TODO Assigned")
  end

  def completed_email
    set_common_params
    mail_to_employee("Quick Teams: TODO Completed")
  end

  def opened_email
    set_common_params
    mail_to_employee("Quick Teams: TODO Re-Opened")
  end

  private

  def set_common_params
    @employee = params[:employee]
    @actor = params[:actor]
    @todo = params[:todo]
  end

  def mail_to_employee(subject)
    mail(
      to: @employee.email,
      subject: subject,
      template_path: TEMPLATE_PATH,
    )
  end
end
