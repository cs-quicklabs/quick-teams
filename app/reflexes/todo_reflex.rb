class TodoReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def toggle_todo
    todo.toggle!(:completed)
    notify_relevant_users
    morph "#todo-status-#{todo.id}", render(partial: "shared/todos/status", locals: { todo: todo })
  end

  private

  def todo
    @todo ||= Todo.find(element.dataset[:id])
  end

  def notify_relevant_users
    email_type = todo.completed ? :completed_email : :opened_email
    recipients_for_notification.each do |recipient|
      deliver_notification(recipient, email_type)
    end
  end

  def recipients_for_notification
    [todo.owner, todo.user].uniq.reject { |user| user == current_user }
  end

  def deliver_notification(recipient, email_type)
    return unless deliverable?(recipient)

    TodosMailer.with(actor: current_user, employee: recipient, todo: todo)
               .public_send(email_type)
               .deliver_later
  end

  def deliverable?(user)
    user.email_enabled && user.account.email_enabled && user.sign_in_count.positive?
  end
end
