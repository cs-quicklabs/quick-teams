class DailyTechNuggetMailer < ApplicationMailer
  def daily_tech_nugget
    @employee = params[:employee]
    @nugget = params[:nugget]
    mail(to: @employee.email, subject: "Nugget of the Day", template_path: "mailers/daily_tech_nugget_mailer")
  end
end
