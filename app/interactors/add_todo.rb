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

  attr_reader :project, :todo, :actor, :employee, :params
end
