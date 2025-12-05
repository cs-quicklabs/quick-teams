class AddNote < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @note = project.notes.new(params)
    @actor = actor
  end

  def call
    add_note
    add_event
    note
  rescue StandardError
    note
  end

  private

  attr_reader :project, :note, :actor

  def add_note
    note.user_id = actor.id
    note.save!
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "noted",
      action_for_context: "added a note for project",
      trackable: note,
    )
  end
end
