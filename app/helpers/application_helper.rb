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
    date.to_date.to_formatted_s(:long)
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

  def login_options
    @redirect_path ? { redirect_to: @redirect_path } : {}
  end

  def convert_string_to_url(text)
    uri_reg = URI.regexp(%w[http https])
    text.gsub(uri_reg) { %{#{$&}'} }
  end

  def ensure_protocol(url)
    if url[/\A(http|https):\/\//i]
      url
    else
      "http://" + url
    end
  end

  def display_xsmall_avatar(resource)
    if resource.avatar.attached?
      image_tag resource.avatar, class: "rounded-full w-6 h-6 object-cover"
    else
      image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "text-xs font-medium text-white leading-none")
      content_tag(:span, image.html_safe, class: "inline-flex  w-6 h-6 items-center justify-center rounded-full bg-gray-500")
    end
  end

  def display_small_avatar(resource)
    if resource.avatar.attached?
      image_tag resource.avatar, class: "rounded-full w-8 h-8 object-cover"
    else
      image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "text-sm font-semibold text-white leading-none")
      content_tag(:span, image.html_safe, class: "inline-flex  w-8 h-8 items-center justify-center rounded-full bg-gray-500")
    end
  end

  def display_medium_avatar(resource)
    if resource.avatar.attached?
      image_tag resource.avatar, class: "rounded-full w-10 h-10 object-cover"
    else
      image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "text-lg font-bold text-white leading-none")
      content_tag(:span, image.html_safe, class: "inline-flex  w-10 h-10 items-center justify-center rounded-full bg-gray-500")
    end
  end

  def display_large_avatar(resource)
    if resource.avatar.attached?
      image_tag resource.avatar, class: "rounded-full w-40 h-40 object-cover"
    else
      image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "text-2xl font-bold text-white leading-none")
      content_tag(:span, image.html_safe, class: "inline-flex  w-40 h-40 items-center justify-center rounded-full bg-gray-500")
    end
  end

  def delete_button(path)
    out = link_to "Delete", path, class: "btn-inline-delete", data: {
                                    controller: "confirmation",
                                    "turbo-method": :delete,
                                    "confirmation-message-value": "Are you sure you want to delete this?",
                                    action: "confirmation#confirm",
                                  }

    out.html_safe
  end

  def styled_delete_button(path, style)
    out = link_to "Delete", path, class: style, data: {
                                    controller: "confirmation",
                                    "turbo-method": :delete,
                                    "confirmation-message-value": "Are you sure you want to delete this?",
                                    action: "confirmation#confirm",
                                  }

    out.html_safe
  end

  def confirm_button(path, title, message, style)
    out = link_to title, path, class: style, data: {
                                 controller: "confirmation",
                                 "confirmation-message-value": message,
                                 action: "confirmation#confirm",
                               }

    out.html_safe
  end

  def edit_button(path)
    out = link_to "Edit", path, class: "btn-inline-edit"

    out.html_safe
  end

  def styled_edit_button(path, style)
    out = link_to "Edit", path, class: style

    out.html_safe
  end
end
