class TodosMailer < ApplicationMailer
  def added_email
    @employee = params[:employee]
    @actor = params[:actor]
    mail(to: @employee.email, subject: "New TODO Assigned", template_path: "mailers/todos_mailer")
  end

  def completed_email
    @employee = params[:employee]
    @actor = params[:actor]
    mail(to: @actor.email, subject: "TODO Completed", template_path: "mailers/todos_mailer")
  end
end
