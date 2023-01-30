class SpacesMailer < ApplicationMailer
  def space_email
    @actor = params[:actor]
    @employee = params[:employee]
    @space = params[:space]
    mail(to: @employee.email, subject: "New Space Created", template_path: "mailers/spaces_mailer")
  end
end
