class WeeklyActivityMailer < ApplicationMailer
  def weekly_summary_email
    @employee = params[:employee]
    @stats = Reports::EmployeeWeeklyStats.new(@employee)

    mail(
      to: @employee.email,
      subject: "Quick Teams: Weekly Summary",
      template_path: "mailers/weekly_activity_mailer",
    )
  end
end
