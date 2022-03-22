class AddExpiredToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :expired, :boolean, default: false, null: false
  end
end
