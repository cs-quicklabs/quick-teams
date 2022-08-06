class AddAboutToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :about, :text
  end
end
