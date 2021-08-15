class NuggetDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_title
    "#{title}".capitalize
  end

  def display_body
    "#{body}".titleize
  end
end
