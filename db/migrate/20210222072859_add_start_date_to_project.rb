class AddStartDateToProject < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :starts_at, :date
    add_column :projects, :ends_at, :date
  end
end
