class Report::TodosController < Report::BaseController
  def my_pending_todos
    authorize :report, :index?

    entries = current_user.created_todos.includes(:project, :owner).pending.order_by_deadline
    @pagy, @todos = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false) if stale?(@todos)
  end

  def pending_todos
    authorize :report, :index?

    entries = Todo.where("deadline <= ?", Date.today).includes(:project, :owner).pending.order_by_deadline
    @pagy, @todos = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false) if stale?(@todos)
  end

  def all_pending_todos
    authorize :report, :index?

    entries = Todo.includes(:project, :owner).pending.order_by_deadline
    @pagy, @todos = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false) if stale?(@todos)
  end

  def recently_added_todos
    authorize :report, :index?

    entries = Todo.includes(:project, :owner).pending.order_by_created
    @pagy, @todos = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false) if stale?(@todos)
  end

  def recently_finished_todos
    authorize :report, :index?

    entries = Todo.includes(:project, :owner).finished.order_by_updated
    @pagy, @todos = pagy_nil_safe(params, entries, items: LIMIT)
    render_partial("report/todos/todo", collection: @todos, cached: false) if stale?(@todos)
  end
end
