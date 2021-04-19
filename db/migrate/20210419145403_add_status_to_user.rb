class AddStatusToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :status, foreign_key: { to_table: :people_statuses }
  end
end
