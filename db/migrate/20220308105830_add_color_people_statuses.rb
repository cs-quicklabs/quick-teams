class AddColorPeopleStatuses < ActiveRecord::Migration[7.0]
  def change
    add_column :ticket_statuses, :color, :string, null: false, default: "gray"
  end
end
