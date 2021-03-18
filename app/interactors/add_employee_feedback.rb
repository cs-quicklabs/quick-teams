class AddEmployeeFeedback < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @feedback = @employee.feedbacks.new params
    @actor = actor
  end

  def call
    add_feedback
    add_event
    feedback
  end

  private

  def add_feedback
    feedback.user_id = actor.id
    feedback.save
  end

  def add_event
    employee.events.create(user: actor, action: "added new feedback.", action_for_context: "added feedback for")
  end

  attr_reader :employee, :feedback, :actor
end
