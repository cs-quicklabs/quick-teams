class AddOwnerToTodo < ActiveRecord::Migration[6.1]
  def change
    add_reference :todos, :owner, foreign_key: { to_table: :users }
    ActsAsTenant.without_tenant do
      Todo.all.each do |todo|
        todo.owner_id = todo.user_id
        todo.save!
      end
    end
    change_column_null :todos, :owner_id, false
  end
end
