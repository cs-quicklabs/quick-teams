class ReportDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_title
    "#{title.upcase_first}"
  end

  def display_body
    "#{body.titleize}"
  end

  def display_status
    if self.submitted?
      "green"
    else
      "blue"
    end
  end
end
