class CreateTableTicketStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_statuses do |t|
      t.string :name
      t.references :account, foreign_key: true, null: false
      t.timestamps
    end
  end
end
