class AddColorToPeopleStatus < ActiveRecord::Migration[6.1]
  def change
  	add_column :people_statuses, :color, :string, null: false, default: "gray"
  end
end
