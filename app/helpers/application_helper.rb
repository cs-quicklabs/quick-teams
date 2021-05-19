module ApplicationHelper
  include Pagy::Frontend

  def tailwind_form_with(**options, &block)
    form_with(**options.merge(builder: TailwindFormBuilder), &block)
  end

  def display_created_at(resource)
    display_date(resource.created_at)
  end

  def display_date(date)
    date.to_date.to_s(:long)
  end

  def goal_path(goal)
    if goal.goalable == "Project"
      project_milestones_path(goal.goalable, goal)
    else
      employee_goals_path(goal.goalable, goal)
    end
  end
end
