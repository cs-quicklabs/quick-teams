class AddColorToProjectTag < ActiveRecord::Migration[6.1]
  def change
    add_column :project_tags, :color, :string, null: false, default: "gray"
  end
end
