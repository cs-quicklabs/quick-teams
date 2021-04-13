class RenameHourToTimesheet < ActiveRecord::Migration[6.1]
  def change
    rename_table :hours, :timesheets
  end
end
