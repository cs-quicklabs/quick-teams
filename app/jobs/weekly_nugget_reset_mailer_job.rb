class WeeklyNuggetResetMailerJob < ApplicationJob
  def perform
    accounts = Account.where(email_enabled: true)
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      users = User.active.where(account: account)
      users.each do |user|
        nuggets = NuggetsUser.where(user: user, read: false).where("created_at < ?", 7.days.ago)
        if nuggets.count > 0
          nuggets.destroy_all
          WeeklyNuggetResetMailer.with(employee: user).nugget_reset_email.deliver_now if user.email_enabled?
        end
      end
    end
  end
end
