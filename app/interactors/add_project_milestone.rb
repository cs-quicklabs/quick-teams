class AddProjectMilestone < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @milestone = project.milestones.new(params)
    @actor = actor
  end

  def call
    add_milestone
    add_event
    milestone
  rescue StandardError
    milestone
  end

  private

  attr_reader :project, :milestone, :actor

  def add_milestone
    milestone.user_id = actor.id
    milestone.save!
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "milestone",
      action_for_context: "added milestone for",
      trackable: milestone,
    )
  end
end
