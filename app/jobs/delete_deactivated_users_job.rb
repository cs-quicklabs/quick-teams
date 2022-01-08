class DeleteDeactivatedUsersJob < ApplicationJob
  def perform
    accounts = Account.all
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      delete_deactivated_users_after_x_days = Preference.find_by(key: "delete_deactivated_users_after_x_days").value
      if delete_deactivated_users_after_x_days != "-1" #Never is selected in settings, skip it
        User.where("account_id = ? AND deactivated_on < ? AND active = false", account.id, delete_deactivated_users_after_x_days.to_i.days.ago).destroy_all
      end
    end
  end
end
