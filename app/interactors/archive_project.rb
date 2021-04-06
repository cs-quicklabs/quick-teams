class ArchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    begin
      clear_schedule
      archive
      add_event
    rescue
      project
    end

    project
  end

  private

  def clear_schedule
    project.schedules.destroy_all
  end

  def archive
    project.archived = true
    project.archived_on = Time.now
    project.manager = nil
    project.save!
  end

  def add_event
    project.events.create(user: actor, action: "archived", action_for_context: "archived", trackable: project)
  end

  attr_reader :project, :actor
end
