class RemoveTodo < Patterns::Service
  def initialize(todo, actor)
    @todo = todo
    @actor = actor
    @employee = todo.user
  end

  def call
    begin
      remove_todo
    rescue
      todo
    end

    todo
  end

  private

  def remove_todo
    todo.destroy
  end

  attr_reader :actor, :todo, :employee
end
