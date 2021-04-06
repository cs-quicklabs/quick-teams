class AddNote < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @note = @project.notes.new params
    @actor = actor
  end

  def call
    begin
      add_note
      add_event
    rescue
      note
    end

    note
  end

  private

  def add_note
    note.user_id = actor.id
    note.save!
  end

  def add_event
    project.events.create(user: actor, action: "noted", action_for_context: "added a note for project", trackable: note)
  end

  attr_reader :project, :note, :actor
end
