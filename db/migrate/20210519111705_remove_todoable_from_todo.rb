class RemoveTodoableFromTodo < ActiveRecord::Migration[6.1]
  def change
    remove_reference :todos, :todoable, polymorphic: true, null: false
  end
end
