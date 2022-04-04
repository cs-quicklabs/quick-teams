class ChangeTicketStatusIdToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :tickets, :ticket_status_id, :integer, null: true
  end
end
