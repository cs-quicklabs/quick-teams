class AddProjectRisk < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @risk = @project.risks.new params
    @actor = actor
  end

  def call
    begin
      add_risk
      add_event
    rescue
      risk
    end

    risk
  end

  private

  def add_risk
    risk.user_id = actor.id
    risk.save!
  end

  def add_event
    project.events.create(user: actor, action: "risk", action_for_context: "added a risk for project", trackable: risk)
  end

  attr_reader :project, :risk, :actor
end
