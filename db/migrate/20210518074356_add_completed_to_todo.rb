class AddCompletedToTodo < ActiveRecord::Migration[6.1]
  def change
    add_column :todos, :completed, :boolean, default: false
  end
end
