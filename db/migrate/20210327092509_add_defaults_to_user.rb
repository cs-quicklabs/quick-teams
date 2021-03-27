class AddDefaultsToUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :first_name, :string, default: "", null: false
    change_column :users, :last_name, :string, default: "", null: false
    change_column :users, :account_id, :integer, null: false
    change_column :users, :job_id, :integer, null: false
    change_column :users, :role_id, :integer, null: false
    change_column :users, :discipline_id, :integer, null: false
  end
end
