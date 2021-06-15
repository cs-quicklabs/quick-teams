class ChangeDeactivatedOnToBeTimestampInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :deactivated_on, :timestamp
  end
end
