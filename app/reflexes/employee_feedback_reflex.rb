class EmployeeFeedbackReflex < ApplicationReflex
  def publish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: true)
    feedback.save!
    FeedbacksMailer.with(feedback: feedback).publish_email.deliver_later if deliver_email?(feedback.critiquable)
  end

  def unpublish
    feedback = Feedback.find(element.dataset["feedback-id"])
    feedback.update(published: false)
    feedback.save!
  end

  def deliver_email?(employee)
    employee.email_enabled and employee.account.email_enabled
  end
end
