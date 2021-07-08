class AddBillableToSchedules < ActiveRecord::Migration[6.1]
  def change
<<<<<<< HEAD
    add_column :schedules, :billable, :bool, default: true
=======
    add_column :schedules, :billable, :bool
>>>>>>> 2fef2d14b613f9d1d5d4626090f1a8e06c66219a
  end
end
