class UserDecorator < Draper::Decorator
  delegate_all

  decorates_association :manager

  def display_name
    "#{first_name} #{last_name}".titleize
  end

  def display_name_position
    "#{first_name} #{last_name}".titleize + " (" + display_role_title + " " + display_job_title + ")".titleize
  end

  def name
    display_name
  end

  def display_job_title
    job.nil? ? "" : "#{job.name}"
  end

  def display_role_title
    role.nil? ? "" : "#{role.name}"
  end

  def display_discipline_title
    discipline.nil? ? "" : "#{discipline.name}"
  end

  def display_position
    display_role_title + " " + display_job_title
  end

  def display_participated_projects
    participated_projects = []
    schedules.each do |schedule|
      participated_projects.push schedule.project.name
    end
    participated_projects.join(", ")
  end

  def display_occupancy
    overall_occupancy.to_s + "%"
  end

  def overall_occupancy
    overall_occupancy = 0
    schedules.each do |schedule|
      overall_occupancy += schedule.occupancy if schedule.billable and schedule.project.billable and schedule.ends_at.to_date.future?
    end
    overall_occupancy
  end

  def display_manager_name
    manager.nil? ? "N/A" : manager.display_name
  end

  def display_additional_team_members
    total_subordinates = subordinates.size
    return total_subordinates <= 4 ? "" : "+#{total_subordinates - 4}"
  end

  def display_team_members_count
    total_subordinates = subordinates.size
    [total_subordinates, 4].min
  end

  def display_deactivated_on
    "#{deactivated_on.to_s(:long)}"
  end

  def display_occupied_till
    busy_untill = schedules.map(&:ends_at).max
    "Occupied untill #{busy_untill.to_s(:long)}"
  end
end
