class AddProjectRisk < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @risk = project.risks.new(params)
    @actor = actor
  end

  def call
    add_risk
    add_event
    risk
  rescue StandardError
    risk
  end

  private

  attr_reader :project, :risk, :actor

  def add_risk
    risk.user_id = actor.id
    risk.save!
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "risk",
      action_for_context: "added a risk for project",
      trackable: risk,
    )
  end
end
