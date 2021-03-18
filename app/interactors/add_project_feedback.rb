class AddProjectFeedback < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @feedback = @project.feedbacks.new params
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
    project.events.create(user: actor, action: "added new feedback.", action_for_context: "added new feedback in project")
  end

  attr_reader :project, :feedback, :actor
end
