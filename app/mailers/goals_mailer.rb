class GoalsMailer < ApplicationMailer
  def created_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "New Goal Created", template_path: "mailers/goals_mailer")
  end
end
