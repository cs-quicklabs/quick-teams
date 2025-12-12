class AddOutputToTimesheet < ActiveRecord::Migration[6.0]
  def change
    add_column :timesheets, :output, :string
  end
end
