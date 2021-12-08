class TodoDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :owner

  def display_title
    "#{title.upcase_first}"
  end

  def display_body
    "#{body.upcase_first}"
  end

  def display_status
    self.completed? ? "green" : "blue"
  end
end
