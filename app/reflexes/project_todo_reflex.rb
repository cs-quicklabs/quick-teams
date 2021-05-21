class ProjectTodoReflex < ApplicationReflex
  def change
    todo = Todo.find(element.dataset[:id])
    todo.update(completed: (todo.completed ? false : true))
    todo.touch
    morph "#todos", render(partial: "project/todos/todo", collection: { todo: @todos })
  end
end
