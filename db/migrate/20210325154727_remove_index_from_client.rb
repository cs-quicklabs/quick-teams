class RemoveIndexFromClient < ActiveRecord::Migration[6.1]
  def change
    remove_index :clients, :email
    add_index :clients, :email
  end
end
