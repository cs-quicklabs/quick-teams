class EmployeeMailer < ApplicationMailer
  def updated_manager_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @employee.email, subject: "Quick Teams: Update regarding your team", template_path: "mailers/employee_mailer")
  end

  def relieved_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @manager.email, subject: "Quick Teams: Update regarding your team", template_path: "mailers/employee_mailer")
  end

  def manager_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @manager.email, subject: "Quick Teams: Update regarding your team", template_path: "mailers/employee_mailer")
  end

  def role_changed_email
    @employee = params[:employee]
    @role = params[:role]
    mail(to: @employee.email, subject: "Quick Teams: Role Changed", template_path: "mailers/employee_mailer")
  end

  def observer_email
    @employee = params[:employee]
    @project = params[:project]
    mail(to: @employee.email, subject: "Quick Teams: You have been added as a project observer", template_path: "mailers/employee_mailer")
  end

  def observer_removed_email
    @employee = params[:employee]
    @project = params[:project]
    mail(to: @employee.email, subject: "Quick Teams: You have been removed as a project observer", template_path: "mailers/employee_mailer")
  end
end
