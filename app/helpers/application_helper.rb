module ApplicationHelper
  include Pagy::Frontend
  include Extractor::HashTag
  include AutoLinkHelper

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
    if goal.goalable_type == "Project"
      project_milestones_path(goal.goalable)
    else
      employee_goals_path(goal.goalable)
    end
  end

  def highlight_hashtag(title)
    hashtags = extract_hashtags(title)
    highlight(title, hashtags.map { |tag| "#" + tag })
  end

  def auto_link_urls_in_text(text)
    auto_link(text, html: { class: "text-indigo-700 hover:underline", target: "_blank" })
  end
end
