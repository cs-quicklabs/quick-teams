class EmployeeFeedbackReflex < ApplicationReflex
  def publish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: true)
    feedback.save!
  end

  def unpublish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: false)
    feedback.save!
  end
end
