class AddDetailsToSchedule < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :starts_at, :date
    add_column :schedules, :ends_at, :date
    add_column :schedules, :occupancy, :integer, inclusion: 0..100
  end
end
