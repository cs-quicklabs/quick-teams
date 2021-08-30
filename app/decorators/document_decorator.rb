class DocumentDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_filename
    "#{filename}"
  end
end
