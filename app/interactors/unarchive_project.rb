class UnarchiveProject < Patterns::Service
  def initialize(project, actor)
    @project = project
    @actor = actor
  end

  def call
    begin
      unarchive
      add_event
    rescue
      project
    end
    project
  end

  private

  def unarchive
    project.archived = false
    project.archived_on = nil
    project.save!
  end

  def add_event
    project.events.create(user: actor, action: "unarchived", action_for_context: "unarchived project", trackable: project)
  end

  attr_reader :project, :actor
end
