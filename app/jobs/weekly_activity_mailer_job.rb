class WeeklyActivityMailerJob < ApplicationJob
  def perform
    accounts = Account.where(email_enabled: true)
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      users = User.active.where(email_enabled: true, account: account)
      users.each do |user|
        stats = Reports::EmployeeWeeklyStats.new(user)
        WeeklyActivityMailer.with(employee: user, stats: stats).weekly_summary_email.deliver_now
      end
    end
  end
end
