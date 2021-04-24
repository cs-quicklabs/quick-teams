module GoalHelper
  def goal_status_color(goal)
    bg_color = "bg-gray-100"
    text_color = "text-gray-800"

    if goal.completed?
      bg_color = "bg-green-100"
      text_color = "text-green-800"
    elsif goal.missed?
      bg_color = "bg-red-100"
      text_color = "text-red-800"
    elsif goal.progress?
      bg_color = "bg-yellow-100"
      text_color = "text-yellow-800"
    end
    bg_color + " " + text_color
  end
end
