class DeleteArchivedProjectsJob < ApplicationJob
  def perform
    Account.find_each do |account|
      ActsAsTenant.with_tenant(account) do
        delete_archived_projects(account)
      end
    end
  end

  private

  def delete_archived_projects(account)
    days_setting = Preference.find_by(key: "delete_archived_projects_after_x_days")&.value
    return if days_setting == "-1" # Never is selected in settings, skip it

    cutoff_date = days_setting.to_i.days.ago
    Project.where(archived: true).where("archived_on < ?", cutoff_date).find_each(&:destroy)
  end
end
