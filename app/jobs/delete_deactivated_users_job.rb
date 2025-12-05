class DeleteDeactivatedUsersJob < ApplicationJob
  def perform
    Account.find_each do |account|
      ActsAsTenant.with_tenant(account) do
        delete_deactivated_users(account)
      end
    end
  end

  private

  def delete_deactivated_users(account)
    days_setting = Preference.find_by(key: "delete_deactivated_users_after_x_days")&.value
    return if days_setting == "-1" # Never is selected in settings, skip it

    cutoff_date = days_setting.to_i.days.ago
    User.where(account_id: account.id, active: false)
        .where("deactivated_on < ?", cutoff_date)
        .find_each(&:destroy)
  end
end
