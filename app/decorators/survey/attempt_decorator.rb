class Survey::AttemptDecorator < Draper::Decorator
  delegate_all

  def display_score
    "NA"
  end
end
