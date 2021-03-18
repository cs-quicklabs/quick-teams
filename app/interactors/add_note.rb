class AddNote < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @note = @project.notes.new params
    @actor = actor
  end

  def call
    add_note
    add_event
    note
  end

  private

  def add_note
    note.user_id = actor.id
    note.save
  end

  def add_event
    project.events.create(user: actor, action: "added new note.", action_for_context: "added a note for project")
  end

  attr_reader :project, :note, :actor
end
