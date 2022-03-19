class TicketDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_title
    "#{title.upcase_first}"
  end

  def display_body
    "#{description.capitalize}"
  end

  def display_status_color
    if self.ticketstatus?
      "green"
    else
      "red"
    end
  end

  def display_status
    if self.ticketstatus?
      "Closed"
    else
      "Open"
    end
  end
end
