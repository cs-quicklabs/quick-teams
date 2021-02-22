class UserDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_name
    "#{first_name} #{last_name}"
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
    overall_occupancy = 0
    schedules.each do |schedule|
      overall_occupancy += schedule.occupancy
    end
    overall_occupancy.to_s + "%"
  end
end
