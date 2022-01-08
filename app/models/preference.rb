class Preference < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :key, :value

  def options_for(key)
    if key == "delete_timesheets_after_x_days"
      [["1 week", "7"], ["1 month", "30"], ["3 months", "90"], ["1 year", "365"], ["Never", "-1"]]
    elsif key == "delete_deactivated_users_after_x_days"
      [["1 year", "365"], ["2 years", "730"], ["3 years", "1095"], ["Never", "-1"]]
    elsif key == "delete_archived_projects_after_x_days"
      [["1 year", "365"], ["2 years", "730"], ["3 years", "1095"], ["Never", "-1"]]
    elsif key == "consider_overall_kpi_score"
      [["Consider previous KPIs score", "true"], ["Consider only current KPIs Score", "false"]]
    elsif key == "transfer_data_to_admin"
      User.where(account: account, permission: :admin).map { |u| [u.decorate.display_name, u.id] }
    end
  end

  def self.transfer_data_to_admin(account)
    admin_id = Preference.where(account: account, key: "transfer_data_to_admin").first.value.to_i
    User.find(admin_id)
  end

  def self.consider_overall_kpi_score(account)
    Preference.where(account: account, key: "consider_overall_kpi_score").first.value == "true"
  end
end
