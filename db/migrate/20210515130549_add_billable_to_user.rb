class AddBillableToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :billable, :boolean, default: true, null: false
  end
end
