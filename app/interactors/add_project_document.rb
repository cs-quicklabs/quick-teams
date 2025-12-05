class AddProjectDocument < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @document = project.documents.new(params)
    @actor = actor
  end

  def call
    add_document
    add_event
    document
  rescue StandardError
    document
  end

  private

  attr_reader :project, :document, :actor

  def add_document
    document.user_id = actor.id
    document.save!
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "document",
      action_for_context: "added new document",
      trackable: document,
    )
  end
end
