class AddEmployeeTodo < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @todo = @employee.todos.new params
    @actor = actor
  end

  def call
    begin
      add_todo
      # add_event
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
    # employee.events.create(user: actor, action: "plan", action_for_context: "added todo for", trackable: todo)
  end

  attr_reader :employee, :todo, :actor
end
