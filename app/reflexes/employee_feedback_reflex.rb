class EmployeeFeedbackReflex < ApplicationReflex
  def publish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: true)
    feedback.save!
    FeedbacksMailer.with(feedback: feedback).publish_email.deliver_later
  end

  def unpublish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: false)
    feedback.save!
  end
end
