class ProjectDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def display_discipline
    "in #{project.discipline.name}"
  end

  def display_created_at
    "#{project.created_at.to_s(:long)}"
  end

  def display_additional_participants
    total_participants = project.participants.count
    return total_participants <= 4 ? "" : "+#{total_participants - 4}"
  end

  def display_participants_count
    total_participants = project.participants.count
    [total_participants, 4].min
  end
end
