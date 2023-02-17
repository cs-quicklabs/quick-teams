class EmployeeMailer < ApplicationMailer
  def updated_manager_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @employee.email, subject: "Manager Updated", template_path: "mailers/employee_mailer")
  end

  def relieved_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @manager.email, subject: "Relieved From Management", template_path: "mailers/employee_mailer")
  end

  def manager_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @manager.email, subject: "New Employee added to your team", template_path: "mailers/employee_mailer")
  end

  def role_changed_email
    @employee = params[:employee]
    @role = params[:role]
    mail(to: @employee.email, subject: "Role Changed", template_path: "mailers/employee_mailer")
  end
end
