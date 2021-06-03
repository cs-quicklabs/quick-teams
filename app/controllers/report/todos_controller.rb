class Report::TodosController < Report::BaseController
  def my_pending_todos
    authorize :report, :index?

    entries = current_user.created_todos.includes(:project, :owner).pending
    @pagy, @todos = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false)
  end

  def pending_todos
    authorize :report, :index?

    entries = Todo.where("deadline <= ?", Date.today).includes(:project, :owner).pending
    @pagy, @todos = pagy_nil_safe(entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false)
  end
end
