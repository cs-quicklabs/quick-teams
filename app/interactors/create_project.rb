class CreateProject < Patterns::Service
  def initialize(params, actor)
    @project = Project.new(params)
    @actor = actor
  end

  def call
    begin
      create_project
      add_event
    rescue
      project
    end

    project
  end

  private

  def create_project
    project.save!
  end

  def add_event
    project.events.create(user: actor, action: "project_created", action_for_context: "added new project", trackable: project)
  end

  attr_reader :project, :actor
end
