class CreateProject < Patterns::Service
  def initialize(params, actor, observers)
    @project = Project.new(params)
    @actor = actor
    @observers = observers&.reject(&:blank?)
  end

  def call
    create_project
    add_observers
    add_event
    project
  rescue StandardError
    project
  end

  private

  attr_reader :project, :actor, :observers

  def create_project
    project.save!
  end

  def add_observers
    return if observers.blank?

    project.observers << User.where(id: observers)
  end

  def add_event
    project.events.create!(
      user: actor,
      action: "project_created",
      action_for_context: "added new project",
      trackable: project,
    )
  end
end
