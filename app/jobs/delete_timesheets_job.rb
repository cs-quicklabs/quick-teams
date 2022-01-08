class DeleteTimesheetsJob < ApplicationJob
  def perform
    accounts = Account.all
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      delete_timesheets_after_x_days = Preference.find_by(key: "delete_timesheets_after_x_days").value
      if delete_timesheets_after_x_days != "-1" #Never is selected in settings, skip it
        Timesheet.where("created_at < ?", delete_timesheets_after_x_days.to_i.days.ago).destroy_all
      end
    end
  end
end
