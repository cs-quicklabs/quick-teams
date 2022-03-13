class AddColumnTicketStatusToTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :ticketstatus, :boolean, default: 0, null: false
  end
end
