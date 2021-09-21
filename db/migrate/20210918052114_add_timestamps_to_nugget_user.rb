class AddTimestampsToNuggetUser < ActiveRecord::Migration[6.1]
  def change
    add_column :nuggets_users, :created_at, :datetime, null: false, default: DateTime.now
    add_column :nuggets_users, :updated_at, :datetime, null: false, default: DateTime.now
  end
end
