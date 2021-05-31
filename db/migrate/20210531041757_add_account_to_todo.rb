class AddAccountToTodo < ActiveRecord::Migration[6.1]
  def change
    add_reference :todos, :account, foreign_key: true, null: true
    ActsAsTenant.without_tenant do
      Todo.all.update_all(account_id: 1)
    end
    change_column_null :todos, :account_id, false
  end
end
