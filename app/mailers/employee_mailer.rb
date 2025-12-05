class EmployeeMailer < ApplicationMailer
  TEMPLATE_PATH = "mailers/employee_mailer"

  def updated_manager_email
    @employee = params[:employee]
    @manager = params[:manager]

    mail_to(@employee.email, "Quick Teams: Update Regarding Your Team")
  end

  def relieved_email
    @employee = params[:employee]
    @manager = params[:manager]

    mail_to(@manager.email, "Quick Teams: Update Regarding Your Team")
  end

  def manager_email
    @employee = params[:employee]
    @manager = params[:manager]

    mail_to(@manager.email, "Quick Teams: Update Regarding Your Team")
  end

  def role_changed_email
    @employee = params[:employee]
    @role = params[:role]

    mail_to(@employee.email, "Quick Teams: Role Changed")
  end

  def observer_email
    @employee = params[:employee]
    @project = params[:project]

    mail_to(@employee.email, "Quick Teams: You Have Been Added as a Project Observer")
  end

  def observer_removed_email
    @employee = params[:employee]
    @project = params[:project]

    mail_to(@employee.email, "Quick Teams: You Have Been Removed as a Project Observer")
  end

  private

  def mail_to(recipient, subject)
    mail(
      to: recipient,
      subject: subject,
      template_path: TEMPLATE_PATH,
    )
  end
end
