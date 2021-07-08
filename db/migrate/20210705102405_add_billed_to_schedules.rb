class AddBilledToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :billed, :int
  end
end
