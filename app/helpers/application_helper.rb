module ApplicationHelper
  include Pagy::Frontend

  def tailwind_form_with(**options, &block)
    form_with(**options.merge(builder: TailwindFormBuilder), &block)
  end

  def display_created_at(resource)
    resource.created_at.to_date.to_s(:long)
  end
end
