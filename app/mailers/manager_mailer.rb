class ManagerMailer < ApplicationMailer
  def updated_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @employee.email, subject: "Manager Updated", template_path: "mailers/manager_mailer")
  end

  def relieved_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @employee.email, subject: "Relieved From Management", template_path: "mailers/manager_mailer")
  end

  def manager_email
    @employee = params[:employee]
    @manager = params[:manager]
    mail(to: @employee.email, subject: "Relieved From Management", template_path: "mailers/manager_mailer")
  end
end
