class DeleteTimesheetsJob < ApplicationJob
  def perform
    Account.find_each do |account|
      ActsAsTenant.with_tenant(account) do
        delete_timesheets
      end
    end
  end

  private

  def delete_timesheets
    days_setting = Preference.find_by(key: "delete_timesheets_after_x_days")&.value
    return if days_setting == "-1" # Never is selected in settings, skip it

    cutoff_date = days_setting.to_i.days.ago
    Timesheet.where("created_at < ?", cutoff_date).find_each(&:destroy)
  end
end
