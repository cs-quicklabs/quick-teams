class AddEmployeeTodo < Patterns::Service
  def initialize(employee, params, actor)
    @employee = employee
    @todo = @employee.todos.new params
    @actor = actor
  end

  def call
    begin
      add_todo
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

  attr_reader :employee, :todo, :actor
end
