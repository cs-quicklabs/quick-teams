class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :description
      t.references :ticket_label, foreign_key: true, null: false
      t.references :discipline, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :ticket_status, foreign_key: true, null: false
      t.references :account, foreign_key: true, null: false
      t.timestamps
    end
  end
end
