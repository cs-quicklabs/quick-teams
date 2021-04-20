class AddProjectGoal < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @goal = @project.goals.new params
    @actor = actor
  end

  def call
    begin
      add_goal
      add_event
    rescue
      goal
    end

    goal
  end

  private

  def add_goal
    goal.user_id = actor.id
    goal.save!
  end

  def add_event
    project.events.create(user: actor, action: "milestone", action_for_context: "added new milestone in project", trackable: goal)
  end

  attr_reader :project, :goal, :actor
end
