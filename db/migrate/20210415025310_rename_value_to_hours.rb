class RenameValueToHours < ActiveRecord::Migration[6.1]
  def change
    rename_column :timesheets, :value, :hours
  end
end
