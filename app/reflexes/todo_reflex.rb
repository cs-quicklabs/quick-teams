class TodoReflex < ApplicationReflex
  def toggle_project_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    TodosMailer.with(actor: todo.user, employee: todo.owner).completed_email.deliver_later if deliver_email?(todo)

    morph "#todo_#{todo.id}", render(partial: "project/todos/todo", locals: { todo: todo })
  end

  def toggle_employee_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    TodosMailer.with(actor: todo.user, employee: todo.owner).completed_email.deliver_later if deliver_email?(todo)
    morph "#todo_#{todo.id}", render(partial: "employee/todos/todo", locals: { todo: todo })
  end

  def deliver_email?(todo)
    todo.completed and todo.user.email_enabled and todo.user.account.email_enabled
  end
end
