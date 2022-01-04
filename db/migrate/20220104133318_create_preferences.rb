class CreatePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :preferences do |t|
      t.string :key
      t.string :value
      t.references :account, foreign_key: true, null: false

      t.timestamps
    end
  end
end
