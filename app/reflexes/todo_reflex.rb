class TodoReflex < ApplicationReflex
  def toggle_project_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    if deliver_email?(todo)
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).completed_email.deliver_later if todo.completed
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).opened_email.deliver_later if !todo.completed
    end
    todo.save!
    morph "#{dom_id(todo)}", render(partial: "project/todos/todo", locals: { todo: todo })
  end

  def toggle_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    if deliver_email?(todo)
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).completed_email.deliver_later if todo.completed
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).opened_email.deliver_later if !todo.completed
    end
    todo.save!
  end

  def toggle_employee_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    if deliver_email?(todo)
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).completed_email.deliver_later if todo.completed
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).opened_email.deliver_later if !todo.completed
    end
    todo.save!
    morph "#{dom_id(todo)}", render(partial: "employee/todos/todo", locals: { todo: todo })
  end

  def deliver_email?(todo)
    todo.user.email_enabled and todo.user.account.email_enabled and todo.user.sign_in_count > 0
  end
end
