class AddEmailEnabledToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :email_enabled, :boolean, default: true
  end
end
