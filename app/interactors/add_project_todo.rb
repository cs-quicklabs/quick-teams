class AddProjectTodo < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @todo = @project.todos.new params
    @actor = actor
  end

  def call
    begin
      add_todo
      add_event
    rescue
      todo
    end

    todo
  end

  private

  def add_todo
    todo.user_id = actor.id
    todo.save!
  end

  def add_event
    project.events.create(user: actor, action: "todo", action_for_context: "added todo for", trackable: todo)
  end

  attr_reader :project, :todo, :actor
end
