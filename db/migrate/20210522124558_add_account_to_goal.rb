class AddAccountToGoal < ActiveRecord::Migration[6.1]
  def change
    add_reference :goals, :account, foreign_key: true
  end
end
