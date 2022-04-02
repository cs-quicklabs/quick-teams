class CreateTableTicketLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_labels do |t|
      t.string :name
      t.references :discipline, foreign_key: true, null: false
      t.references :account, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
