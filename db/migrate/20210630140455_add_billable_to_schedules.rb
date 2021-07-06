class AddBillableToSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :schedules, :billable, :bool, default: true
  end
end
