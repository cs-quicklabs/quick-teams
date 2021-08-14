class AddPrimaryColumnToNuggetsusers < ActiveRecord::Migration[6.1]
  def change
    add_column :nuggets_users, :id, :primary_key
  end
end
