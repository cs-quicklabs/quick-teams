module AvatarHelper
  def display_xsmall_avatar(resource)
    display_avatar(resource, "w-7 h-7", "text-xs")
  end

  def display_small_avatar(resource)
    display_avatar(resource, "w-8 h-8", "text-sm")
  end

  def display_medium_avatar(resource)
    display_avatar(resource, "w-10 h-10", "text-lg")
  end

  def display_large_avatar(resource)
    display_avatar(resource, "w-40 h-40", "text-xl")
  end

  def display_avatar(resource, image_size, text_size)
    image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "#{text_size} font-semibold text-white leading-none")
    content_tag(:span, image.html_safe, class: "inline-flex items-center justify-center rounded-full bg-gray-500 ring-2 ring-white #{image_size}")

    # if resource.avatar.attached?
    #   image_tag resource.avatar, class: "rounded-full object-cover #{image_size}"
    # else
    #   image = content_tag(:span, (resource.first_name[0, 1] + resource.last_name[0, 1]).upcase, class: "#{text_size} font-semibold text-white leading-none")
    #   content_tag(:span, image.html_safe, class: "inline-flex items-center justify-center rounded-full bg-gray-500 ring-2 ring-white #{image_size}")
    # end
  end
end
