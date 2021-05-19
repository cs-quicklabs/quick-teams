class ChangeHoursToDecimal < ActiveRecord::Migration[6.1]
  def change
    change_column :timesheets, :hours, :decimal, :precision => 4, :scale => 2
  end
end
