class AddProjectDocument < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @document = @project.documents.new params
    @actor = actor
  end

  def call
    begin
      add_document
      add_event
    rescue
      document
    end

    document
  end

  private

  def add_document
    document.user_id = actor.id
    document.save!
  end

  def add_event
    project.events.create(user: actor, action: "document", action_for_context: "added new document in project", trackable: document)
  end

  attr_reader :project, :document, :actor
end
