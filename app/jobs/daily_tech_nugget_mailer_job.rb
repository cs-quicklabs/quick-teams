class DailyTechNuggetMailerJob < ApplicationJob
  def perform
    accounts = Account.where(email_enabled: true)
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      users = User.active.where(email_enabled: true, account: account)
      users.each do |user|
        all_published_nugget_ids_for_user = Nugget.where(published: true, skill_id: user.skills.pluck(:id)).pluck(:id)
        seen_nuggets_ids = NuggetsUser.where(user_id: user.id).pluck(:nugget_id)
        unseen_nugget_ids = all_published_nugget_ids_for_user - seen_nuggets_ids
        nugget_id = unseen_nugget_ids.sample

        if nugget_id.present?
          nugget = Nugget.find(nugget_id)
          NuggetsUser.new(user_id: user.id, nugget_id: nugget.id, read: false).save!
          DailyTechNuggetMailer.with(employee: user, nugget: nugget).daily_tech_nugget.deliver_now
        end
      end
    end
  end
end
