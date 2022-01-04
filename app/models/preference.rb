class Preference < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :key, :value

  def self.options_for(key)
    if key == "delete_timesheets_after_x_days"
      [["1 week", "7"], ["1 month", "30"], ["3 months", "180"], ["1 year", "365"], ["Never", "-1"]]
    elsif key == "delete_deactivated_user_after_x_days"
      [["1 year", "365"], ["2 years", "730"], ["3 years", "1095"], ["Never", "-1"]]
    elsif key == "delete_archived_projects_after_x_days"
      [["1 year", "365"], ["2 years", "730"], ["3 years", "1095"], ["Never", "-1"]]
    end
  end
end
