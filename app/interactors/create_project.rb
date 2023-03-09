class CreateProject < Patterns::Service
  def initialize(params, actor, observers)
    @project = Project.new(params)
    @actor = actor
    @observers = observers.reject(&:blank?) if observers
  end

  def call
    begin
      create_project
      add_observers
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

  def add_observers
    project.observers << User.where("id IN (?)", observers)
  end

  def add_event
    project.events.create(user: actor, action: "project_created", action_for_context: "added new project", trackable: project)
  end

  attr_reader :project, :actor, :observers
end
