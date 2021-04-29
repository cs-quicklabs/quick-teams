class GoalDecorator < Draper::Decorator
  delegate_all
  decorates_association :comment
  decorates_association :user

  def display_owner
    if goalable_type == "User"
      goalable.decorate.display_name
    else
      goalable.name
    end
  end

  def display_subtitle
    if goalable_type == "User"
      "Employee Goal"
    else
      "Project Milestone"
    end
  end

  def color
    if goal.progress?
      "yellow"
    elsif goal.completed?
      "green"
    elsif goal.missed?
      "red"
    else goal.discarded?
      "gray"     end
  end
end
