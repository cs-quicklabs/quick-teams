class AddStatusToProject < ActiveRecord::Migration[6.1]
  def change
    add_reference :projects, :status, foreign_key: { to_table: :project_statuses }
  end
end
