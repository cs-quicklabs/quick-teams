class AddProjectToTodo < ActiveRecord::Migration[6.1]
  def change
    add_reference :todos, :project, null: false, foreign_key: true
  end
end
