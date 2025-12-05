class WeeklyActivityMailerJob < ApplicationJob
  def perform
    Account.where(email_enabled: true).find_each do |account|
      ActsAsTenant.with_tenant(account) do
        send_weekly_summaries(account)
      end
    end
  end

  private

  def send_weekly_summaries(account)
    User.active.where(email_enabled: true, account: account).find_each do |user|
      stats = Reports::EmployeeWeeklyStats.new(user)
      WeeklyActivityMailer.with(employee: user, stats: stats).weekly_summary_email.deliver_now
    end
  end
end
