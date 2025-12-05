class RemoveTodo < Patterns::Service
  def initialize(todo, actor)
    @todo = todo
    @actor = actor
  end

  def call
    todo.destroy!
    todo
  rescue StandardError
    todo
  end

  private

  attr_reader :actor, :todo
end
