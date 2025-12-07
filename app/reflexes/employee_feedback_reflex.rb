class EmployeeFeedbackReflex < ApplicationReflex
  def publish
    update_feedback(true)
    send_publish_email if deliver_email?(feedback.critiquable)
    morph_feedback_status
  end

  def unpublish
    update_feedback(false)
    morph_feedback_status
  end

  private

  def feedback
    @feedback ||= Feedback.find(element.dataset["feedback-id"])
  end

  def update_feedback(published)
    feedback.update!(published: published)
  end

  def morph_feedback_status
    morph "#feedback-status-#{feedback.id}", render(partial: "employee/feedbacks/status", locals: { feedback: feedback })
  end

  def send_publish_email
    FeedbacksMailer.with(feedback: feedback).publish_email.deliver_later
  end

  def deliver_email?(employee)
    employee.email_enabled && employee.account.email_enabled && employee.sign_in_count.positive?
  end
end
