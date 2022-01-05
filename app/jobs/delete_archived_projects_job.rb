class DeleteArchivedProjectsJob < ApplicationJob
  def perform
    accounts = Account.all
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      delete_archived_projects_after_x_days = Preference.find_by(key: "delete_archived_projects_after_x_days").value
      if delete_archived_projects_after_x_days != "-1" #Never is selected in settings, skip it
        Project.where("archived = true AND archived_on < ?", delete_archived_projects_after_x_days.to_i.days.ago).destroy_all
      end
    end
  end
end
