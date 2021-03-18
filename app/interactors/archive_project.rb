class ArchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    clear_schedule
    archive
    add_event
    project
  end

  private

  def clear_schedule
    project.schedules.destroy_all
  end

  def archive
    project.archived = true
    project.archived_on = Time.now
    project.save
  end

  def add_event
    project.events.create(user: actor, action: "archived project.", action_for_context: "archived")
  end

  attr_reader :project, :actor
end
