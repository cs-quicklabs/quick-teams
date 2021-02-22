class AddDetailsToProject < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :manager, foreign_key: { to_table: :users }
    add_reference :projects, :discipline, foreign_key: true
  end
end
