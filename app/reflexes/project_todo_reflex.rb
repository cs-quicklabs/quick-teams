class ProjectTodoReflex < ApplicationReflex
  def toggle_project_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    TodosMailer.with(actor: todo.user, employee: todo.owner).completed_email.deliver_later if todo.completed

    morph "#todo_#{todo.id}", render(partial: "project/todos/todo", locals: { todo: todo })
  end

  def toggle_employee_todo
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: !todo.completed)
    TodosMailer.with(actor: todo.user, employee: todo.owner).completed_email.deliver_later if todo.completed
    morph "#todo_#{todo.id}", render(partial: "employee/todos/todo", locals: { todo: todo })
  end
end
