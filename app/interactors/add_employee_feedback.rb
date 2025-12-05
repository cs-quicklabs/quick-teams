class AddEmployeeFeedback < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @feedback = employee.feedbacks.new(params)
    @actor = actor
  end

  def call
    add_feedback
    add_event
    feedback
  rescue StandardError
    feedback
  end

  private

  attr_reader :employee, :feedback, :actor

  def add_feedback
    feedback.user_id = actor.id
    feedback.published = false
    feedback.save!
  end

  def add_event
    employee.events.create!(
      user: actor,
      action: "feedback",
      action_for_context: "added feedback for",
      trackable: feedback,
    )
  end
end
