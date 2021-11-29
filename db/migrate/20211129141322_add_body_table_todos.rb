class AddBodyTableTodos < ActiveRecord::Migration[7.0]
 def change
    add_column :todos, :body, :text
  end
end
