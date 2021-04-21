class CreateHours < ActiveRecord::Migration[6.1]
  def change
    create_table :hours do |t|
      t.references :account, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value, null: false, default: 0
      t.date :date, null: false
      t.string :description, null: false
      t.boolean :billed, null: false, default: false
      t.boolean :billable, null: false, default: true

      t.timestamps
    end
  end
end
