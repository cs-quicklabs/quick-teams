class CreateJobCards < ActiveRecord::Migration[7.1]
  def change

    create_table :job_cards do |t|
      t.string :title, null: false
      t.text :description
      t.date :date, null: false
      t.integer :session, null: false
      t.integer :slot_start, null: false
      t.integer :slot_length, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :job_cards, [:date, :session]
  end
end
