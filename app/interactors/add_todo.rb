class AddTodo < Patterns::Service
  def initialize(todo, project, employee, params, actor)
    @todo = todo
    @project = project
    @employee = employee
    @actor = actor
    @params = params
  end

  def call
    begin
      add_project_todo
      # add_event
    rescue
      todo
    end

    todo
  end

  private

  def add_project_todo
    todo.update(params)
    todo.project = @project
    todo.user = @employee
    todo.save!
  end

  def add_event
    # project.events.create(user: actor, action: "todo", action_for_context: "added todo for", trackable: todo)
  end

  attr_reader :project, :todo, :actor, :employee, :params
end
