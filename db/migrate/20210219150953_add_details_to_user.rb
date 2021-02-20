class AddDetailsToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :role, foreign_key: true
    add_reference :users, :discipline, foreign_key: true
    add_reference :users, :job, foreign_key: true
    add_reference :users, :manager, foreign_key: { to_table: :users }
  end
end
