class AddDeadlineToGoal < ActiveRecord::Migration[6.1]
  def change
    add_column :goals, :deadline, :date
    add_column :goals, :status, :integer, null: false, default: 0
  end
end
