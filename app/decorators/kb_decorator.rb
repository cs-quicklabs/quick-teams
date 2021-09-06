class KbDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_document
    "#{document}".capitalize
  end
end
