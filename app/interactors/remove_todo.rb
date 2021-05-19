class RemoveTodo < Patterns::Service
  def initialize(todo, actor)
    @todo = todo
    @actor = actor
    @employee = todo.user
  end

  def call
    begin
      remove_todo
      # add_event
    rescue
      todo
    end

    todo
  end

  private

  def remove_todo
    todo.destroy
  end

  def add_event
    # employee.events.create(user: actor, action: "freed", action_for_context: "freed", trackable: schedule.project)
  end

  attr_reader :actor, :todo, :employee
end
