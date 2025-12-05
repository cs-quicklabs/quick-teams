class AddProjectTodo < Patterns::Service
  def initialize(project, params, actor)
    @project = project
    @todo = project.todos.new(params)
    @actor = actor
  end

  def call
    add_todo
    send_email
    todo
  rescue StandardError
    todo
  end

  private

  attr_reader :project, :todo, :actor

  def add_todo
    todo.project = project
    todo.user_id = actor.id
    todo.save!
  end

  def send_email
    return unless deliver_email?

    TodosMailer.with(actor: actor, employee: todo.owner, todo: todo)
               .added_email
               .deliver_later
  end

  def deliver_email?
    actor != todo.owner &&
      todo.owner.email_enabled &&
      todo.owner.account.email_enabled &&
      todo.owner.sign_in_count.positive?
  end
end
