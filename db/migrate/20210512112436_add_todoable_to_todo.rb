class AddTodoableToTodo < ActiveRecord::Migration[6.1]
  def change
  	add_reference :todos, :todoable, polymorphic: true, null: false
  end
end
