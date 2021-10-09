class RiskDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def risk_status_color
    if self.status?
      "red"
    else
      "green"
    end
  end

  def risk_status_action
    if self.status?
      "green"
    else
      "red"
    end
  end
end
