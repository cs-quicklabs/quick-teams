class AddPermissionToGoals < ActiveRecord::Migration[7.0]
  def change
    add_column :goals, :permission, :boolean, null: false, default: false
  end
end
