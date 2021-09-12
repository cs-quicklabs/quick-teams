class ProjectDecorator < Draper::Decorator
  delegate_all

  def display_name
    name.upcase_first
  end

  def display_discipline
    "in #{project.discipline.name}"
  end

  def display_manager_name
    project.manager.nil? ? "N/A" : project.manager.decorate.display_name
  end

  def display_archived_on
    "#{project.archived_on.to_s(:long)}"
  end

  def display_additional_participants
    total_participants = project.participants.size
    return total_participants <= 4 ? "" : "+#{total_participants - 4}"
  end

  def display_participants_count
    total_participants = project.participants.size
    [total_participants, 4].min
  end
end
