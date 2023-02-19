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

  def send_email(user, todo)
    if current_user.admin? || current_user.manager?
      if todo.user == todo.owner and deliver_email?(todo.user, current_user)
        TodosMailer.with(actor: current_user, employee: todo.user, todo: todo).completed_email.deliver_later if todo.completed
        TodosMailer.with(actor: current_user, employee: todo.user, todo: todo).opened_email.deliver_later if !todo.completed
      elsif todo.user != todo.owner and todo.completed
        TodosMailer.with(actor: current_user, employee: todo.owner, todo: todo).completed_email.deliver_later if deliver_email?(todo.owner, current_user)
        TodosMailer.with(actor: current_user, employee: todo.user, todo: todo).completed_email.deliver_later if deliver_email?(todo.user, current_user)
      elsif todo.user != todo.owner and !todo.completed
        TodosMailer.with(actor: current_user, employee: todo.owner, todo: todo).opened_email.deliver_later if deliver_email?(todo.owner, current_user)
        TodosMailer.with(actor: current_user, employee: todo.user, todo: todo).opened_email.deliver_later if deliver_email?(todo.user, current_user)
      end
    elsif current_user == todo.owner and deliver_email?(todo.user, todo.owner)
      TodosMailer.with(actor: todo.owner, employee: todo.user, todo: todo).completed_email.deliver_later if todo.completed
      TodosMailer.with(actor: todo.owner, employee: todo.user, todo: todo).opened_email.deliver_later if !todo.completed
    elsif current_user == todo.user and deliver_email?(todo.owner, todo.user)
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).completed_email.deliver_later if todo.completed
      TodosMailer.with(actor: todo.user, employee: todo.owner, todo: todo).opened_email.deliver_later if !todo.completed
    end
  end

  def deliver_email?(user, actor)
    actor != user and user.email_enabled and user.account.email_enabled and user.sign_in_count > 0
  end
end
