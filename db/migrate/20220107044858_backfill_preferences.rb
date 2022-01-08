class BackfillPreferences < ActiveRecord::Migration[7.0]
  def change
    accounts = Account.all
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      Preference.new(key: "delete_deactivated_users_after_x_days", value: "365", title: "Delete deactivated users after a specified time", message: "You can destroy old deactivated users automatically after a certain time. Please select time after which deactivated users can be deleted ").save
      Preference.new(key: "delete_timesheets_after_x_days", value: "90", title: "Delete timesheets after a specific time duration", message: "The timesheets recorded will be deleted after below specified time. This helps to keep only those records which are needed. Please select time after which old timesheets can be deleted").save
      Preference.new(key: "delete_archived_projects_after_x_days", value: "365", title: "Delete archived projects after a specified time", message: "You can destroy old archived projects automatically after a certain time. Please select time after which archived projects can be deleted ").save
      Preference.new(key: "consider_overall_kpi_score", value: "true", title: "Consider overall KPI score when KPIs are changed", message: "When KPIs are changed for an employee, do you wish to consider previous KPIs in overall score or just the new KPIs score should be considered while calculating final score").save
      Preference.new(key: "transfer_data_to_admin", value: User.where(account: account, permission: :admin).first.id, title: "Transfer data to admin on user delete", message: "When a user is deleted, you might want to keep some of the data like nuggets, Knowledge Base or Report Templates. Whom do you wish to assign this data when the user is deleted").save
    end
  end
end
