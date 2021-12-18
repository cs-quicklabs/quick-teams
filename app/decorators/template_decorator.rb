class TemplateDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_title
    "#{title.upcase_first}"
  end

  def display_body
    "#{body.titleize}"
  end
end
