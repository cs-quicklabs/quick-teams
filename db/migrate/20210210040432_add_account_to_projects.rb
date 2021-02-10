class AddAccountToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :account_id, :integer
    add_index :projects, :account_id
  end
end
