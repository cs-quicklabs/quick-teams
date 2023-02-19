class TodoReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def toggle_project_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    send_email(current_user, todo)
    todo.save!
    morph "#{dom_id(todo)}", render(partial: "project/todos/todo", locals: { todo: todo })
  end

  def toggle_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    send_email(current_user, todo)
    todo.save!
  end

  def toggle_employee_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    send_email(current_user, todo)
    todo.save!
    morph "#{dom_id(todo)}", render(partial: "employee/todos/todo", locals: { todo: todo })
  end

  def send_email(actor, todo)
    todo.completed ? send_completed_email(actor, todo) : send_opened_email(actor, todo)
  end

  def send_completed_email(actor, todo)
    if actor == todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).completed_email.deliver_later if deliver_email?(todo.user, actor)
    elsif actor == todo.user
      TodosMailer.with(actor: actor, employee: todo.owner, todo: todo).completed_email.deliver_later if deliver_email?(todo.owner, actor)
    elsif actor != todo.owner and actor != todo.user and todo.user != todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).completed_email.deliver_later if deliver_email?(todo.user, actor)
      TodosMailer.with(actor: actor, employee: todo.owner, todo: todo).completed_email.deliver_later if deliver_email?(todo.owner, actor)
    elsif actor != todo.owner and actor != todo.user and todo.user == todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).completed_email.deliver_later if deliver_email?(todo.user, actor)
    end
  end

  def send_opened_email(actor, todo)
    if actor == todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).opened_email.deliver_later if deliver_email?(todo.user, actor)
    elsif actor == todo.user
      TodosMailer.with(actor: actor, employee: todo.owner, todo: todo).opened_email.deliver_later if deliver_email?(todo.owner, actor)
    elsif actor != todo.owner and actor != todo.user and todo.user != todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).opened_email.deliver_later if deliver_email?(todo.user, actor)
      TodosMailer.with(actor: actor, employee: todo.owner, todo: todo).opened_email.deliver_later if deliver_email?(todo.owner, actor)
    elsif actor != todo.owner and actor != todo.user and todo.user == todo.owner
      TodosMailer.with(actor: actor, employee: todo.user, todo: todo).opened_email.deliver_later if deliver_email?(todo.user, actor)
    end
  end

  def deliver_email?(user, actor)
    actor != user and user.email_enabled and user.account.email_enabled and user.sign_in_count > 0
  end
end
