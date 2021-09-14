class AddColorToProjectStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :project_statuses, :color, :string, null: false, default: "gray"
  end
end
