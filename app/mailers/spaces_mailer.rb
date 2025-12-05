class SpacesMailer < ApplicationMailer
  TEMPLATE_PATH = "mailers/spaces_mailer"

  def space_email
    set_common_params
    mail_to_employee("Quick Teams: New Space Created")
  end

  def archived_email
    set_common_params
    mail_to_employee("Quick Teams: Space Archived")
  end

  def unarchived_email
    set_common_params
    mail_to_employee("Quick Teams: Space Unarchived")
  end

  private

  def set_common_params
    @actor = params[:actor]
    @employee = params[:employee]
    @space = params[:space]
  end

  def mail_to_employee(subject)
    mail(
      to: @employee.email,
      subject: subject,
      template_path: TEMPLATE_PATH,
    )
  end
end
