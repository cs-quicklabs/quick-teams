class GoalsMailer < ApplicationMailer
  TEMPLATE_PATH = "mailers/goals_mailer"

  def created_email
    set_common_params
    mail_to_employee("Quick Teams: New Goal Created")
  end

  def commented_email
    set_common_params
    mail_to_employee("Quick Teams: New Comment on Goal")
  end

  def missed_email
    set_common_params
    mail_to_employee("Quick Teams: Goal Missed")
  end

  def completed_email
    set_common_params
    mail_to_employee("Quick Teams: Goal Completed")
  end

  def discarded_email
    set_common_params
    mail_to_employee("Quick Teams: Goal Discarded")
  end

  private

  def set_common_params
    @actor = params[:actor]
    @employee = params[:employee]
    @goal = params[:goal]
  end

  def mail_to_employee(subject)
    mail(
      to: @employee.email,
      subject: subject,
      template_path: TEMPLATE_PATH,
    )
  end
end
