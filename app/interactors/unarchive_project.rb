class UnarchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    unarchive
    add_event
    project
  rescue StandardError
    project
  end

  private

  attr_reader :project, :actor

  def unarchive
    project.update!(archived: false, archived_on: nil)
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "unarchived",
      action_for_context: "unarchived project",
      trackable: project,
    )
  end
end
