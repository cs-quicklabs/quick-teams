module ApplicationHelper
  include Pagy::Frontend

  def tailwind_form_with(**options, &block)
    form_with(**options.merge(builder: TailwindFormBuilder), &block)
  end

  def display_created_at(resource)
    display_date(resource.created_at)
  end

  def display_date(date)
    date.to_s(:long)
  end
end
