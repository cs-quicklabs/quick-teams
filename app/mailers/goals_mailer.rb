class GoalsMailer < ApplicationMailer
  def created_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "Quick Teams: New Goal Created", template_path: "mailers/goals_mailer")
  end

  def commented_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "Quick Teams: New Comment on Goal", template_path: "mailers/goals_mailer")
  end

  def missed_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "Quick Teams: Goal Missed", template_path: "mailers/goals_mailer")
  end

  def completed_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "Quick Teams: Goal Completed", template_path: "mailers/goals_mailer")
  end

  def discarded_email
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
    mail(to: @employee.email, subject: "Quick Teams: Goal Discarded", template_path: "mailers/goals_mailer")
  end
end
