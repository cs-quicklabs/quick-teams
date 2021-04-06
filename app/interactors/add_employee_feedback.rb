class AddEmployeeFeedback < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @feedback = @employee.feedbacks.new params
    @actor = actor
  end

  def call
    begin
      add_feedback
      add_event
    rescue
      feedback
    end

    feedback
  end

  private

  def add_feedback
    feedback.user_id = actor.id
    feedback.save!
  end

  def add_event
    employee.events.create(user: actor, action: "feedback", action_for_context: "added feedback for", trackable: feedback)
  end

  attr_reader :employee, :feedback, :actor
end
